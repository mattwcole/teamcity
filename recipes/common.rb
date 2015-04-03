archive_info = node['teamcity']['url'].match(/(\w+)-((?:\d\.*)+)\.tar\.gz$/)

ark archive_info[0] do
  url node['teamcity']['url']
  checksum node['teamcity']['checksum']
  name archive_info[1]
  version archive_info[2]
  notifies :run, 'execute[runAll.sh]'
end

execute 'runAll.sh' do
  script_path = File.join(node['ark']['prefix_home'], "#{archive_info[1]}-#{archive_info[2]}", 'bin/runAll.sh')

  command "#{script_path} start" 
  action :nothing
end
