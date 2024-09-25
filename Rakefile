require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'opal/rspec/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

Opal::RSpec::RakeTask.new(:opal) do |_, config|
  Opal.append_path File.join(__dir__, 'lib')
  Opal.use_gem('gamefic')
  Opal.use_gem('gamefic-what')
  config.default_path = 'spec'
  config.pattern = 'spec/**/*_spec.rb'
  config.requires = ['opal_helper']
end
