require 'test_helper'
require 'generators/loco/notification_center/notification_center_generator'

module Loco
  class Loco::NotificationCenterGeneratorTest < Rails::Generators::TestCase
    tests Loco::NotificationCenterGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
