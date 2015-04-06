describe 'teamcity::default' do
  context 'default attributes' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    %w(java teamcity::server).each do |recipe|
      it "requires #{recipe} recipe" do
        expect(chef_run).to include_recipe(recipe)
        expect(chef_run).not_to include_recipe('teamcity::server_windows')
      end
    end
  end

  context 'java install disabled' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['teamcity']['install_java'] = false
      end.converge(described_recipe)
    end

    it 'does not require java recipe' do
      expect(chef_run).not_to include_recipe('java')
    end
  end

  # context 'windows family' do
  #   let(:chef_run) do
  #     ChefSpec::SoloRunner.new(platform_family: 'windows', version: '2012r2') do |node|
  #       node.set['java']['oracle']['accept_oracle_download_terms'] = true
  #     end.converge(described_recipe)
  #   end

  #   it 'requires server_windows recipe' do
  #     expect(chef_run).to include_recipe('teamcity::server_windows')
  #     expect(chef_run).not_to include_recipe('teamcity::server')
  #   end
  # end
end
