require 'test_helper'
require 'generators/loco/file_injector/file_injector_generator'

module Loco
  class Loco::FileInjectorGeneratorTest < Rails::Generators::TestCase
    tests Loco::FileInjectorGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
