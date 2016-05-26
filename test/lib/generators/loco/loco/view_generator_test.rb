require 'test_helper'
require 'generators/loco/view/view_generator'

module Loco
  class Loco::ViewGeneratorTest < Rails::Generators::TestCase
    tests Loco::ViewGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
