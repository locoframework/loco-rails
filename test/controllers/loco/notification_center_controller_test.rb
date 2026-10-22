# frozen_string_literal: true

require 'test_helper'

module Loco
  class NotificationCenterControllerTest < ActionDispatch::IntegrationTest
    test 'index returns notifications and the next sync time' do
      Loco.emit({ event: :published }, subject: articles(:one))
      get '/notification-center', params: { synced_at: 3.seconds.ago.iso8601(6) }
      response.parsed_body => { notifications:, synced_at: next_synced_at }
      assert_response :success
      assert_equal 1, notifications.size
      assert_equal %w[Article published], notifications.first.values_at('obj_class', 'type')
      assert Time.zone.parse(next_synced_at)
    end

    # loco-js sends `synced_at=null` on its first check, having no sync point yet:
    # no backlog replay, and the sync point comes back in the same response
    test 'index handles a client without a sync time' do
      Loco.emit({ event: :published }, subject: articles(:one))
      get '/notification-center', params: { synced_at: 'null' }
      response.parsed_body => { notifications:, synced_at: next_synced_at }
      assert_response :success
      assert_empty notifications
      assert_in_delta Loco::Notification::Fetch::OVERLAP.ago, Time.zone.parse(next_synced_at), 1
    end
  end
end
