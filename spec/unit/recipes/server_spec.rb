describe 'teamcity::server' do
  context 'optionals attributes set' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['teamcity']['data_path'] = 'data_path'
        node.set['teamcity']['server_opts'] = 'server_opts'
        node.set['teamcity']['server_mem_opts'] = 'server_mem_opts'
      end.converge(described_recipe)
    end

    before do
      stub_command('data_path').and_return(true)
    end

    it 'creates user' do
      expect(chef_run).to create_group(chef_run.node['teamcity']['group'])
      expect(chef_run).to create_user(chef_run.node['teamcity']['user'])
        .with(gid: chef_run.node['teamcity']['group'])
    end

    it 'creates data directory' do
      expect(chef_run).to create_directory(chef_run.node['teamcity']['data_path'])
        .with(owner: chef_run.node['teamcity']['user'])
    end

    it 'downloads and extracts archive' do
      chef_run.node.set['teamcity']['url'] = 'http://jetbrains.com/TeamCity-1.0.0.tar.gz'
      chef_run.converge(described_recipe)

      expect(chef_run).to install_archive('TeamCity-1.0.0.tar.gz')
        .with(checksum: chef_run.node['teamcity']['checksum'])
        .with(owner: chef_run.node['teamcity']['user'])
        .with(prefix_root: chef_run.node['teamcity']['install_path'])
        .with(prefix_home: chef_run.node['teamcity']['install_path'])
    end

    it 'creates init script' do
      chef_run.node.set['teamcity']['url'] = 'http://jetbrains.com/TeamCity-1.0.0.tar.gz'
      chef_run.converge(described_recipe)

      expect(chef_run).to create_template('/etc/init.d/teamcity')
        .with(source: 'teamcity.init.erb')
        .with(variables:
        {
          :user => chef_run.node['teamcity']['user'],
          :run_script => '/usr/local/TeamCity-1.0.0/bin/runAll.sh',
          :data_path => chef_run.node['teamcity']['data_path'],
          :server_opts => chef_run.node['teamcity']['server_opts'],
          :server_mem_opts => chef_run.node['teamcity']['server_mem_opts']
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
end
