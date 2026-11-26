# frozen_string_literal: true

require 'test_helper'

module Loco
  # the dummy app's cable runs on Redis, so broadcasts are checked with a spy
  class NotificationCenterChannelTest < TCWithMocks
    include ActionCable::Channel::TestCase::Behavior

    tests NotificationCenterChannel

    test 'a ping carries the sync point, OVERLAP behind now' do
      freeze_time
      uuid = SecureRandom.uuid
      stub_connection(loco_permissions: [uuid, users(:zbig)])
      subscribe
      allow(NotificationCenterChannel).to receive(:broadcast_to)

      subscription.perform_action('loco' => { 'pong' => true }) # as the client sends it: JSON, no action

      expect(NotificationCenterChannel).to have_received(:broadcast_to)
        .with(uuid, loco: { ping: true, synced_at: Notification::Fetch::OVERLAP.ago.iso8601(6) })
    end
  end
end
