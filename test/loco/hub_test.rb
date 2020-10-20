# frozen_string_literal: true

require 'test_helper'

module Loco
  class HubTest < TC
    include WsHelpers

    describe '#add_member' do
      it 'returns members' do
        hub = Hub.new('foobar', [users(:zbig)])
        hub.add_member(users(:jane))
        assert_equal [users(:zbig), users(:jane)], hub.members
      end
    end

    describe '#connected_uuids' do
      it do
        uuid = SecureRandom.uuid
        create_connection(users(:jane), uuid)
        hub = Hub.new('foobar', [users(:zbig), users(:jane)])
        assert_equal [uuid], hub.connected_uuids
      end
    end

    describe '#members' do
      it 'returns members' do
        hub = Hub.new('foobar', [users(:zbig), users(:jane)])
        assert_equal [users(:zbig), users(:jane)], hub.members
      end
    end

    describe '#name' do
      it 'returns a name' do
        hub = Hub.new('foobar', [users(:zbig), users(:jane)])
        assert_equal 'foobar', hub.name
      end
    end
  end
end
