# frozen_string_literal: true

require 'test_helper'

module Loco
  class Notification
    class FetchTest < ActiveSupport::TestCase
      test 'should limit notifications to Loco::Config.notifications_size' do
        size = Loco::Config.notifications_size
        Loco.configure { |c| c.notifications_size = 2 }
        3.times { Loco.emit({ event: :published }, subject: articles(:one)) }
        assert_equal 2, fetch(synced_at: 3.seconds.ago.iso8601(6))[:notifications].size
      ensure
        Loco.configure { |c| c.notifications_size = size }
      end

      test 'should limit notifications to max_size' do
        3.times { Loco.emit({ event: :published }, subject: articles(:one)) }
        assert_equal 2, fetch(synced_at: 3.seconds.ago.iso8601(6), max_size: 2)[:notifications].size
      end

      describe 'synced_at' do
        before { freeze_time }

        it 'moves to OVERLAP behind now on a short page' do
          travel_to(10.seconds.ago) { Loco.emit({ event: :published }, subject: articles(:one)) }
          assert_equal Fetch::OVERLAP.ago.iso8601(6), fetch(synced_at: 20.seconds.ago.iso8601(6))[:synced_at]
        end

        it 'moves to OVERLAP behind now when nothing is returned, so an idle client stays fresh' do
          assert_equal Fetch::OVERLAP.ago.iso8601(6), fetch(synced_at: 2.hours.ago.iso8601(6))[:synced_at]
        end

        it 'stays OVERLAP behind now, so a row committed late is still fetched' do
          Loco.emit({ event: :published }, subject: articles(:one))
          assert_equal Fetch::OVERLAP.ago.iso8601(6), fetch(synced_at: 1.second.ago.iso8601(6))[:synced_at]
        end

        it 'moves strictly forward on a full page' do
          2.times { Loco.emit({ event: :published }, subject: articles(:one)) }
          assert_equal Notification.maximum(:updated_at).iso8601(6),
                       fetch(synced_at: 1.second.ago.iso8601(6), max_size: 2)[:synced_at]
        end
      end

      describe 'gap' do
        before { Loco.configure { |c| c.notifications_retention = 1.hour } }
        after { Loco.configure { |c| c.notifications_retention = nil } }

        it 'is flagged when the sync point is older than the retention' do
          assert fetch(synced_at: 61.minutes.ago.iso8601(6))[:gap]
        end

        it 'is not flagged within the retention' do
          assert_not fetch(synced_at: 59.minutes.ago.iso8601(6))[:gap]
        end

        it 'is not flagged without a sync point' do
          assert_not fetch(synced_at: 'null')[:gap]
        end

        it 'is not flagged without a retention' do
          Loco.configure { |c| c.notifications_retention = nil }
          assert_not fetch(synced_at: 1.year.ago.iso8601(6))[:gap]
        end
      end

      test 'should not return addressed notifications without passing correct permissions' do
        Loco.emit({ event: :published }, subject: articles(:one), to: admin_support_members(:one))
        assert_empty fetch[:notifications]
      end

      test 'should not return addressed notifications when passed incorrect permissions' do
        Loco.emit({ event: :published }, subject: articles(:one), to: admin_support_members(:two))
        assert_empty fetch(permissions: [admin_support_members(:one)])[:notifications]
      end

      test 'should return addressed notifications when passed correct permissions' do
        Loco.emit({ event: :published }, subject: articles(:one), to: admin_support_members(:one))
        assert_equal 1, fetch(permissions: [admin_support_members(:one)])[:notifications].size
      end

      test 'pemissions as class' do
        Loco.emit({ event: :published }, subject: articles(:one), to: Admin::SupportMember)
        assert_equal 1, fetch(permissions: [admin_support_members(:one)])[:notifications].size
        assert_equal 1, fetch(permissions: [admin_support_members(:two)])[:notifications].size
      end

      test 'fetching with recipient token' do
        Loco.emit({ event: :published }, subject: articles(:one), to: '123qweasd')
        assert_equal 1, fetch(recipient_token: '123qweasd')[:notifications].size
      end

      private

      def fetch(synced_at: 3.seconds.ago.iso8601(6), permissions: [], recipient_token: nil, **)
        Fetch.(synced_at:, permissions:, recipient_token:, **)
      end
    end
  end
end
