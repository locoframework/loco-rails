require 'test_helper'
require 'generators/loco/initializer/initializer_generator'

module Loco
  class Loco::InitializerGeneratorTest < Rails::Generators::TestCase
    tests Loco::InitializerGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
