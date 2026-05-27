# frozen_string_literal: true

require 'test_helper'

module Loco
  class SenderTest < TCWithMocks
    include WsHelpers

    describe '.call' do
      before do
        setup_connections
        @data = Data.(idempotency_key: 'foobarbaz')
      end

      it 'sends data via WS to recipients' do
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('random_uuid', @data)
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#1', @data)
        Sender.new([users(:zbig), 'random_uuid']).(@data)
      end

      it 'does not mutate a passed data' do
        Sender.new('foobarbaz').(@data)
        assert_equal(Data.(idempotency_key: 'foobarbaz'), @data)
      end

      it 'returns idempotency_key' do
        key = SecureRandom.hex
        assert_equal key, Sender.new(users(:zbig)).(Data.(idempotency_key: key))
      end

      it 'sends a passed idempotency key' do
        uuid = SecureRandom.uuid
        expect(NotificationCenterChannel).to receive(:broadcast_to).with(uuid, @data)
        Sender.new(uuid).(@data)
      end

      it 'accepts a hash with token' do
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#6', @data)
        Sender.new({ 'token' => 'random-token' }).(@data)
      end

      it 'accepts a hash with class' do
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#3', @data)
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#3.1', @data)
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#4', @data)
        Sender.new({ 'class' => 'Admin::SupportMember' }).(@data)
      end

      it 'sends to a given UUID only once' do
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#1', @data).once
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#2', @data).once

        Sender.new([users(:zbig), User]).(@data)
      end
    end
  end
end
