require 'test_helper'
require 'generators/loco/js_assets_structure/js_assets_structure_generator'

module Loco
  class Loco::JsAssetsStructureGeneratorTest < Rails::Generators::TestCase
    tests Loco::JsAssetsStructureGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
