require 'spec_helper'

describe 'teamcity::default' do

  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  %w(java teamcity::server).each do |recipe|
    it "requires #{recipe} recipe" do
      expect(chef_run).to include_recipe(recipe)      
    end
  end

  context 'windows family' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012r2').converge(described_recipe)
    end

    it 'requires server_windows recipe' do
      expect(chef_run).to include_recipe('teamcity::server_windows')
      expect(chef_run).not_to include_recipe('teamcity::server')
    end    
  end  
end
