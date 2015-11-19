require 'test_helper'

module Loco
  class Notification::FetcherTest < ActiveSupport::TestCase
    def setup
      @emitter = Class.new{ include Loco::Emitter }.new
    end

    test "should not return addressed notifications without passing correct permissions" do
      fetcher = Notification::Fetcher.new synced_at: 3.seconds.ago.iso8601(6)
      @emitter.emit articles(:one), :published, for: admins(:one)
      assert_empty fetcher.formatted_notifications
    end

    test "should not return addressed notifications when passed incorrect permissions" do
      fetcher = Notification::Fetcher.new synced_at: 3.seconds.ago.iso8601(6), permissions: [current_admin]
      @emitter.emit articles(:one), :published, for: admins(:two)
      assert_empty fetcher.formatted_notifications
    end

    test "should return addressed notifications when passed correct permissions" do
      fetcher = Notification::Fetcher.new synced_at: 3.seconds.ago.iso8601(6), permissions: [current_admin]
      @emitter.emit articles(:one), :published, for: admins(:one)
      assert_equal 1, fetcher.formatted_notifications.size
    end

    test "pemissions as class" do
      fetcher = Notification::Fetcher.new synced_at: 3.seconds.ago.iso8601(6), permissions: [current_admin(:one)]
      fetcher2 = Notification::Fetcher.new synced_at: 3.seconds.ago.iso8601(6), permissions: [current_admin(:two)]
      @emitter.emit articles(:one), :published, for: Admin
      assert_equal 1, fetcher.formatted_notifications.size
      assert_equal 1, fetcher2.formatted_notifications.size
    end

    test "fetching with recipient token" do
      fetcher = Notification::Fetcher.new synced_at: 3.seconds.ago.iso8601(6), recipient_token: "123qweasd"
      @emitter.emit articles(:one), :published, for: "123qweasd"
      assert_equal 1, fetcher.formatted_notifications.size
    end

    private

      def current_admin(which = :one); admins which end
  end
end