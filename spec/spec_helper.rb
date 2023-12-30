require "bundler/setup"
require 'simplecov'
SimpleCov.start

require "gamefic-standard"

# @todo This is a temporary wart during the update to v3.
#   A better solution is to make a TestPlot in a fixture.
Gamefic::Plot.include Gamefic::Standard

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :each do
    @original = Gamefic::Plot.blocks.clone
  end

  config.after :each do
    Gamefic::Plot.blocks.replace @original
  end
end
