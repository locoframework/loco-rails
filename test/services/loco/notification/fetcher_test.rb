# frozen_string_literal: true

require 'test_helper'

module Loco
  class Notification
    class FetcherTest < ActiveSupport::TestCase
      test 'should set max_size via Loco::Config' do
        Loco.configure { |c| c.notifications_size = 1000 }
        assert_equal 1000, Notification::Fetcher.new(synced_at: 3.seconds.ago.iso8601(6))
                                                .max_size
      end

      test 'should set max_size on initialization' do
        opts = { synced_at: 3.seconds.ago.iso8601(6), max_size: 101 }
        assert_equal 101, Notification::Fetcher.new(opts).max_size
      end

      test 'should not return addressed notifications without passing correct permissions' do
        fetcher = Notification::Fetcher.new synced_at: 3.seconds.ago.iso8601(6)
        Loco.emit articles(:one), :published, for: admin_support_members(:one)
        assert_empty fetcher.formatted_notifications
      end

      test 'should not return addressed notifications when passed incorrect permissions' do
        fetcher = Notification::Fetcher.new(
          synced_at: 3.seconds.ago.iso8601(6),
          permissions: [current_admin]
        )
        Loco.emit articles(:one), :published, for: admin_support_members(:two)
        assert_empty fetcher.formatted_notifications
      end

      test 'should return addressed notifications when passed correct permissions' do
        fetcher = Notification::Fetcher.new(
          synced_at: 3.seconds.ago.iso8601(6),
          permissions: [current_admin]
        )
        Loco.emit articles(:one), :published, for: admin_support_members(:one)
        assert_equal 1, fetcher.formatted_notifications.size
      end

      test 'pemissions as class' do
        fetcher = Notification::Fetcher.new(
          synced_at: 3.seconds.ago.iso8601(6),
          permissions: [current_admin(:one)]
        )
        fetcher2 = Notification::Fetcher.new(
          synced_at: 3.seconds.ago.iso8601(6),
          permissions: [current_admin(:two)]
        )
        Loco.emit articles(:one), :published, for: Admin::SupportMember
        assert_equal 1, fetcher.formatted_notifications.size
        assert_equal 1, fetcher2.formatted_notifications.size
      end

      test 'fetching with recipient token' do
        fetcher = Notification::Fetcher.new(
          synced_at: 3.seconds.ago.iso8601(6),
          recipient_token: '123qweasd'
        )
        Loco.emit articles(:one), :published, for: '123qweasd'
        assert_equal 1, fetcher.formatted_notifications.size
      end

      private

      def current_admin(which = :one)
        admin_support_members(which)
      end
    end
  end
end
