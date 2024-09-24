require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'opal/rspec/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

Opal::RSpec::RakeTask.new(:opal) do |_, config|
  Opal.append_path File.expand_path('../lib', __FILE__)
  Opal.use_gem('gamefic')
  Opal.use_gem('gamefic-what')
  config.pattern = 'spec/**/*_spec.rb'
  config.requires = ['spec_helper']
end
