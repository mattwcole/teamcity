describe 'teamcity::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  %w(java teamcity::server).each do |recipe|
    it "requires #{recipe} recipe" do
      expect(chef_run).to include_recipe(recipe)
      expect(chef_run).not_to include_recipe('teamcity::server_windows')
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
