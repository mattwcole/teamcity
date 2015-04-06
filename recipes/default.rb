include_recipe 'java' if node['teamcity']['install_java']

if node['platform_family'] == 'windows'
  include_recipe 'teamcity::server_windows'
else
  include_recipe 'teamcity::server'
end
