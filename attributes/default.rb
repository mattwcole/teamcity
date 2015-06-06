default['teamcity']['url'] = 'http://download.jetbrains.com/teamcity/TeamCity-9.0.3.tar.gz'
default['teamcity']['checksum'] = 'cacef22cf53506346078c05ff9c12dd5bd773c90596cf72fbf4ff49ff8493d1a'
default['teamcity']['user'] = 'teamcity'
default['teamcity']['user_group'] = 'teamcity'
default['teamcity']['user_home'] = '/home/teamcity'
default['teamcity']['install_path'] = '/usr/local/teamcity'
default['teamcity']['data_path'] = nil
default['teamcity']['server_opts'] = nil
default['teamcity']['server_mem_opts'] = nil
default['teamcity']['log_path'] = nil
default['teamcity']['install_java'] = true

default['java']['jdk_version'] = '7'
default['java']['install_flavor'] = 'oracle' if node[platform_family] == windows
