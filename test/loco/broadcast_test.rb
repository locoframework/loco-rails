# frozen_string_literal: true

require 'test_helper'

module Loco
  class BroadcastTest < TCWithMocks
    include WsHelpers

    describe '.call' do
      before do
        setup_connections
        @data = { loco: { idempotency_key: 'foobarbaz' } }
      end

      it 'sends data via WS to recipients' do
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('random_uuid', @data)
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#1', @data)
        Broadcast.new([users(:zbig), 'random_uuid']).(@data)
      end

      it 'does not mutate a passed data' do
        Broadcast.new('foobarbaz').(@data)
        assert_equal({ loco: { idempotency_key: 'foobarbaz' } }, @data)
      end

      it 'sends a passed idempotency key' do
        uuid = SecureRandom.uuid
        expect(NotificationCenterChannel).to receive(:broadcast_to).with(uuid, @data)
        Broadcast.new(uuid).(@data)
      end

      it 'accepts a hash with token' do
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#6', @data)
        Broadcast.new({ 'token' => 'random-token' }).(@data)
      end

      it 'accepts a hash with class' do
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#3', @data)
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#3.1', @data)
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#4', @data)
        Broadcast.new({ 'class' => 'Admin::SupportMember' }).(@data)
      end

      it 'sends to a given UUID only once' do
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#1', @data).once
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#2', @data).once

        Broadcast.new([users(:zbig), User]).(@data)
      end
    end
  end
end
