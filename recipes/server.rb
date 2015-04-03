archive_info = node['teamcity']['url'].match(/(\w+)-((?:\d\.*)+)\.tar\.gz$/)

group node['teamcity']['group']

user node['teamcity']['user'] do
  gid node['teamcity']['group']
end

ark archive_info[0] do
  url node['teamcity']['url']
  checksum node['teamcity']['checksum']
  name archive_info[1]
  version archive_info[2]
  owner node['teamcity']['user']
end

template '/etc/init.d/teamcity' do
  source 'teamcity.init.erb'
  variables ({
    :script_path => File.join(node['ark']['prefix_home'], "#{archive_info[1]}-#{archive_info[2]}", 'bin/runAll.sh'),
    :user => node['teamcity']['user']
  })
  mode '755'
  notifies :start, 'service[teamcity]'
end

service 'teamcity' do    
  action :nothing
end
