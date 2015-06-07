default['teamcity']['url'] = 'http://download.jetbrains.com/teamcity/TeamCity-9.0.4.tar.gz'
default['teamcity']['checksum'] = '479c5834ecee8fd9ba1fb8afc2e47b163c8ff8275d5b591769a2f9e038be0527'
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
