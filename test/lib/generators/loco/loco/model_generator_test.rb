require 'test_helper'
require 'generators/loco/model/model_generator'

module Loco
  class Loco::ModelGeneratorTest < Rails::Generators::TestCase
    tests Loco::ModelGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
