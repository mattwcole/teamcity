require 'spec_helper'

describe 'teamcity::server' do

  let(:chef_run) do
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  it 'requires common recipe' do
    expect(chef_run).to include_recipe('teamcity::common')    
  end 
end
