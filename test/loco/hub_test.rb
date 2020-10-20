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

    describe '#del_member' do
      it 'returns members' do
        hub = Hub.new('foobar', [users(:zbig), users(:jane)])
        hub.del_member(users(:jane))
        assert_equal [users(:zbig)], hub.members
      end
    end

    describe '#destroy' do
      it 'destroys' do
        hub = Hub.new('foobar', [users(:zbig), users(:jane)])
        hub.save
        assert_equal 'foobar', Hub.get('foobar').name
        hub.destroy
        assert_nil Hub.get('foobar')
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

    describe '#save' do
      # tested in #destroy
    end
  end
end
