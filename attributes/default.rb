default['java']['install_flavor'] = 'oracle' if node[platform_family] == windows

default['teamcity']['url'] = 'http://download.jetbrains.com/teamcity/TeamCity-9.0.3.tar.gz'
default['teamcity']['checksum'] = 'cacef22cf53506346078c05ff9c12dd5bd773c90596cf72fbf4ff49ff8493d1a'
default['teamcity']['user'] = 'teamcity'
default['teamcity']['group'] = 'teamcity'
default['teamcity']['install_path'] = '/usr/local'
default['teamcity']['data_path'] = nil
default['teamcity']['server_opts'] = nil
default['teamcity']['server_mem_opts'] = nil
