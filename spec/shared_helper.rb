# frozen_string_literal: true

require 'gamefic-standard'
# @todo Including Standard here to fix entity namespaces in specs
include Gamefic::Standard

require_relative 'fixtures/test_plot'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.after :each do
    TestPlot.blocks.clear
  end
end