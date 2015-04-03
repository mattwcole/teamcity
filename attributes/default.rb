default['java']['jdk_version'] = 7
if node[platform_family] == windows
  default['java']['install_flavor'] = 'oracle'
end

default['teamcity']['url'] = 'http://download.jetbrains.com/teamcity/TeamCity-9.0.3.tar.gz'
default['teamcity']['checksum'] = 'cacef22cf53506346078c05ff9c12dd5bd773c90596cf72fbf4ff49ff8493d1a'
default['teamcity']['user'] = 'teamcity'
default['teamcity']['group'] = 'teamcity'
default['teamcity']['data_path'] = nil
