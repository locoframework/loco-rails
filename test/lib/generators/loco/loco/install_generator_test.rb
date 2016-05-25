require 'test_helper'
require 'generators/loco/install/install_generator'

module Loco
  class Loco::InstallGeneratorTest < Rails::Generators::TestCase
    tests Loco::InstallGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
