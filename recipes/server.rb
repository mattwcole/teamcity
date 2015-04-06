archive_info = node['teamcity']['url'].match(/(\w+)-((?:\d\.*)+)\.tar\.gz$/)
archive_filename = archive_info[0]
archive_name = archive_info[1]
archive_version = archive_info[2]

group node['teamcity']['group']

user node['teamcity']['user'] do
  gid node['teamcity']['group']
end

directory node['teamcity']['data_path'].to_s do
  owner node['teamcity']['user']
  only_if node['teamcity']['data_path']
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
  variables(
    :user => node['teamcity']['user'],
    :run_script => File.join(node['teamcity']['install_path'], "#{archive_name}-#{archive_version}", 'bin/runAll.sh'),
    :data_path => node['teamcity']['data_path'],
    :server_opts => node['teamcity']['server_opts'],
    :server_mem_opts => node['teamcity']['server_mem_opts'])
  mode '755'
  notifies :enable, 'service[teamcity]'
  notifies :restart, 'service[teamcity]'
end

service 'teamcity' do
  action :nothing
end
