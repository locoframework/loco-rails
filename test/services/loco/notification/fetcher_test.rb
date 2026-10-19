# frozen_string_literal: true

require 'test_helper'

module Loco
  class Notification
    class FetcherTest < ActiveSupport::TestCase
      test 'should limit notifications to Loco::Config.notifications_size' do
        size = Loco::Config.notifications_size
        Loco.configure { |c| c.notifications_size = 2 }
        fetcher = Notification::Fetcher.new synced_at: 3.seconds.ago.iso8601(6)
        3.times { Loco.emit({ event: :published }, subject: articles(:one)) }
        assert_equal 2, fetcher.formatted_notifications.size
      ensure
        Loco.configure { |c| c.notifications_size = size }
      end

      test 'should limit notifications to max_size' do
        fetcher = Notification::Fetcher.new synced_at: 3.seconds.ago.iso8601(6), max_size: 2
        3.times { Loco.emit({ event: :published }, subject: articles(:one)) }
        assert_equal 2, fetcher.formatted_notifications.size
      end

      describe 'next_sync_time' do
        before { freeze_time }

        it 'is the newest notification returned' do
          travel_to(10.seconds.ago) { Loco.emit({ event: :published }, subject: articles(:one)) }
          fetcher = Notification::Fetcher.new synced_at: 20.seconds.ago.iso8601(6)
          assert_equal Notification.maximum(:created_at), fetcher.next_sync_time
        end

        it 'stays put when nothing is returned' do
          synced_at = 20.seconds.ago.iso8601(6)
          assert_equal synced_at, Notification::Fetcher.new(synced_at:).next_sync_time.iso8601(6)
        end

        it 'stays OVERLAP behind now, so a row committed late is still fetched' do
          Loco.emit({ event: :published }, subject: articles(:one))
          fetcher = Notification::Fetcher.new synced_at: 1.second.ago.iso8601(6)
          assert_equal Fetcher::OVERLAP.ago, fetcher.next_sync_time
        end

        it 'moves strictly forward on a full page' do
          2.times { Loco.emit({ event: :published }, subject: articles(:one)) }
          fetcher = Notification::Fetcher.new synced_at: 1.second.ago.iso8601(6), max_size: 2
          assert_equal Notification.maximum(:created_at), fetcher.next_sync_time
        end
      end

      test 'should not return addressed notifications without passing correct permissions' do
        fetcher = Notification::Fetcher.new synced_at: 3.seconds.ago.iso8601(6)
        Loco.emit({ event: :published }, subject: articles(:one), to: admin_support_members(:one))
        assert_empty fetcher.formatted_notifications
      end

      test 'should not return addressed notifications when passed incorrect permissions' do
        fetcher = Notification::Fetcher.new(
          synced_at: 3.seconds.ago.iso8601(6),
          permissions: [current_admin]
        )
        Loco.emit({ event: :published }, subject: articles(:one), to: admin_support_members(:two))
        assert_empty fetcher.formatted_notifications
      end

      test 'should return addressed notifications when passed correct permissions' do
        fetcher = Notification::Fetcher.new(
          synced_at: 3.seconds.ago.iso8601(6),
          permissions: [current_admin]
        )
        Loco.emit({ event: :published }, subject: articles(:one), to: admin_support_members(:one))
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
        Loco.emit({ event: :published }, subject: articles(:one), to: Admin::SupportMember)
        assert_equal 1, fetcher.formatted_notifications.size
        assert_equal 1, fetcher2.formatted_notifications.size
      end

      test 'fetching with recipient token' do
        fetcher = Notification::Fetcher.new(
          synced_at: 3.seconds.ago.iso8601(6),
          recipient_token: '123qweasd'
        )
        Loco.emit({ event: :published }, subject: articles(:one), to: '123qweasd')
        assert_equal 1, fetcher.formatted_notifications.size
      end

      private

      def current_admin(which = :one)
        admin_support_members(which)
      end
    end
  end
end
