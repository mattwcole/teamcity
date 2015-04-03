require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'foodcritic'

task default: %w(ruby_style chef_style chef_spec)

desc 'Runs Ruby style checks'
RuboCop::RakeTask.new(:ruby_style)

desc 'Runs Chef style checks'
FoodCritic::Rake::LintTask.new(:chef_style) do |f|
  f.options = {
    fail_tags: ['any']
  }
end

desc 'Runs ChefSpec tests'
RSpec::Core::RakeTask.new(:chef_spec)
