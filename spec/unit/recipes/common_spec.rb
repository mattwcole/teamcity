require 'spec_helper'

describe 'teamcity::common' do

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['teamcity']['url'] = 'http://jetbrains.com/TeamCity-1.0.0.tar.gz'
    end.converge(described_recipe)
  end

  it 'downloads and extracts teamcity archive' do
    expect(chef_run).to install_archive('TeamCity-1.0.0.tar.gz')
      .with(checksum: chef_run.node['teamcity']['checksum'])    
  end

  it 'runs teamcity server' do
    expect(chef_run.ark('TeamCity-1.0.0.tar.gz')).to notify('execute[runAll.sh]')
      .to(:run).delayed      

    script_path = File.join(chef_run.node['ark']['prefix_home'],'TeamCity-1.0.0/bin/runAll.sh')

    expect(chef_run.execute('runAll.sh')).to do_nothing
    expect(chef_run.execute('runAll.sh').command).to match("#{script_path} start")
  end
end
