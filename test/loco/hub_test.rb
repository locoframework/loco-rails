# frozen_string_literal: true

require 'test_helper'

module Loco
  class HubTest < TC
    include WsHelpers

    describe '#connected_uuids' do
      it do
        uuid = SecureRandom.uuid
        create_connection(users(:jane), uuid)
        hub = Hub.new('foobar', [users(:zbig), users(:jane)])
        assert_equal [uuid], hub.connected_uuids
      end
    end
  end
end