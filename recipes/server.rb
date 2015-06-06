data_path = node['teamcity']['data_path'] || File.join(node['teamcity']['user_home'], '.BuildServer')

group node['teamcity']['user_group']

user node['teamcity']['user'] do
  gid node['teamcity']['user_group']
  home node['teamcity']['user_home']
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

ark File.basename(node['teamcity']['install_path']) do
  url node['teamcity']['url']
  checksum node['teamcity']['checksum']
  path File.dirname(node['teamcity']['install_path'])
  owner node['teamcity']['user']
  action :put
end

template '/etc/init.d/teamcity' do
  source 'teamcity.init.erb'
  variables :run_script => File.join(node['teamcity']['install_path'], 'bin/runAll.sh')
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
