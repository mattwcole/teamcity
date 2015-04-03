describe 'teamcity::server' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['teamcity']['url'] = 'http://jetbrains.com/TeamCity-1.0.0.tar.gz'
    end.converge(described_recipe)
  end

  it 'creates user' do
    expect(chef_run).to create_group(chef_run.node['teamcity']['group'])
    expect(chef_run).to create_user(chef_run.node['teamcity']['user'])
      .with(gid: chef_run.node['teamcity']['group'])
  end

  it 'downloads and extracts archive' do
    expect(chef_run).to install_archive('TeamCity-1.0.0.tar.gz')
      .with(checksum: chef_run.node['teamcity']['checksum'])
      .with(owner: chef_run.node['teamcity']['user'])
  end

  it 'creates init script' do
    expect(chef_run).to create_template('/etc/init.d/teamcity')
      .with(source: 'teamcity.init.erb')
      .with(variables:
      {
        :script_path => File.join(chef_run.node['ark']['prefix_home'], 'TeamCity-1.0.0/bin/runAll.sh'),
        :user => chef_run.node['teamcity']['user'],
        :data_path => chef_run.node['teamcity']['data_path']
      })
      .with(mode: '755')
  end

  it 'enables and restarts service' do
    expect(chef_run.service('teamcity')).to do_nothing
    expect(chef_run.template('/etc/init.d/teamcity')).to notify('service[teamcity]')
      .to(:enable)
      .to(:restart)
  end
end
