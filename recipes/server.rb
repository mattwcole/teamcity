archive_info = node['teamcity']['url'].match(/(\w+)-((?:\d\.*)+)\.tar\.gz$/)
archive_filename = archive_info[0]
archive_name = archive_info[1]
archive_version = archive_info[2]
data_path = node['teamcity']['data_path'] || File.join(node['teamcity']['home'], '.BuildServer')

group node['teamcity']['group']

user node['teamcity']['user'] do
  gid node['teamcity']['group']
  home node['teamcity']['home']
  manage_home true
end

directory data_path do
  owner node['teamcity']['user']
  recursive true
end

directory File.join(data_path, 'config') do
  owner node['teamcity']['user']
end

directory node['teamcity']['log_path'].to_s do
  owner node['teamcity']['user']
  only_if { node['teamcity']['log_path'] }
end

ark archive_filename do
  url node['teamcity']['url']
  checksum node['teamcity']['checksum']
  name archive_name
  version archive_version
  owner node['teamcity']['user']
  prefix_root node['teamcity']['install_path']
  prefix_home node['teamcity']['install_path']
end

template '/etc/init.d/teamcity' do
  source 'teamcity.init.erb'
  variables :run_script => File.join(node['teamcity']['install_path'], "#{archive_name}-#{archive_version}", 'bin/runAll.sh')
  mode '755'
  notifies :enable, 'service[teamcity]'
  notifies :restart, 'service[teamcity]'
end

template File.join(data_path, 'config/internal.properties') do
  source 'internal.properties.erb'
  owner node['teamcity']['user']
end

service 'teamcity' do
  action :nothing
end
