describe 'teamcity::server' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  it 'creates user' do
    expect(chef_run).to create_group(chef_run.node['teamcity']['user_group'])
    expect(chef_run).to create_user(chef_run.node['teamcity']['user'])
      .with(gid: chef_run.node['teamcity']['user_group'])
      .with(home: chef_run.node['teamcity']['user_home'])
      .with(manage_home: true)
  end

  context 'default data directory' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['teamcity']['data_path'] = nil
        node.set['teamcity']['user_home'] = 'teamcity_home'
      end.converge(described_recipe)
    end

    it 'creates data directory in teamcity user home' do
      expect(chef_run).to create_directory('teamcity_home/.BuildServer')
        .with(owner: chef_run.node['teamcity']['user'])
        .with(recursive: true)
    end

    it 'creates config directory in teamcity user home' do
      expect(chef_run).to create_directory('teamcity_home/.BuildServer/config')
        .with(owner: chef_run.node['teamcity']['user'])
    end

    it 'creates internal properties file in teamcity user home' do
      expect(chef_run).to create_template('teamcity_home/.BuildServer/config/internal.properties')
        .with(source: 'internal.properties.erb')
        .with(owner: chef_run.node['teamcity']['user'])
    end
  end

  context 'custom data directory' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['teamcity']['data_path'] = 'data_path'
      end.converge(described_recipe)
    end

    it 'creates data directory' do
      expect(chef_run).to create_directory(chef_run.node['teamcity']['data_path'])
        .with(owner: chef_run.node['teamcity']['user'])
        .with(recursive: true)
    end

    it 'creates config directory' do
      expect(chef_run).to create_directory('data_path/config')
        .with(owner: chef_run.node['teamcity']['user'])
    end

    it 'creates internal properties file' do
      expect(chef_run).to create_template('data_path/config/internal.properties')
        .with(source: 'internal.properties.erb')
        .with(owner: chef_run.node['teamcity']['user'])
    end
  end

  context 'default log directory' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['teamcity']['log_path'] = nil
      end.converge(described_recipe)
    end

    it 'does not create log directory' do
      expect(chef_run).not_to create_directory(chef_run.node['teamcity']['log_path'])
    end
  end

  context 'custom log directory' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['teamcity']['log_path'] = 'log_path'
      end.converge(described_recipe)
    end

    it 'creates log directory' do
      expect(chef_run).to create_directory('log_path')
    end
  end

  it 'downloads and extracts archive' do
    expect(chef_run).to put_archive('teamcity')
      .with(url: chef_run.node['teamcity']['url'])
      .with(checksum: chef_run.node['teamcity']['checksum'])
      .with(owner: chef_run.node['teamcity']['user'])
      .with(path: File.dirname(chef_run.node['teamcity']['install_path']))
  end

  it 'creates init script' do
    expect(chef_run).to create_template('/etc/init.d/teamcity')
      .with(source: 'teamcity.init.erb')
      .with(variables: { :run_script => '/usr/local/teamcity/bin/runAll.sh' })
      .with(mode: '755')
  end

  it 'enables and restarts service' do
    expect(chef_run.service('teamcity')).to do_nothing
    expect(chef_run.template('/etc/init.d/teamcity')).to notify('service[teamcity]')
      .to(:enable)
      .to(:restart)
  end
end
