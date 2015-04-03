archive_info = node['teamcity']['url'].match(/(\w+)-((?:\d\.*)+)\.tar\.gz$/)
archive_filename = archive_info[0]
archive_name = archive_info[1]
archive_version = archive_info[2]

group node['teamcity']['group']

user node['teamcity']['user'] do
  gid node['teamcity']['group']
end

ark archive_filename do
  url node['teamcity']['url']
  checksum node['teamcity']['checksum']
  name archive_name
  version archive_version
  owner node['teamcity']['user']
end

template '/etc/init.d/teamcity' do
  source 'teamcity.init.erb'
  variables(
    :script_path => File.join(node['ark']['prefix_home'], "#{archive_info[1]}-#{archive_info[2]}", 'bin/runAll.sh'),
    :user => node['teamcity']['user'],
    :data_path => node['teamcity']['data_path'])
  mode '755'
  notifies :enable, 'service[teamcity]'
  notifies :restart, 'service[teamcity]'
end

service 'teamcity' do
  action :nothing
end
