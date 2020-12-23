# frozen_string_literal: true

require 'test_helper'

module Loco
  class SenderTest < TCWithMocks
    include WsHelpers

    describe '.call' do
      before do
        setup_connections
        @payload = { loco: { idempotency_key: 'foobarbaz' } }
      end

      it 'sends payload via WS to recipients' do
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('random_uuid', @payload)
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#1', @payload)
        Sender.([users(:zbig), 'random_uuid'], { idempotency_key: 'foobarbaz' })
      end

      it 'does not mutate a passed payload' do
        payload = { foo: 'bar' }
        Sender.('foobarbaz', payload)
        assert_equal({ foo: 'bar' }, payload)
      end

      it 'returns idempotency_key' do
        key = SecureRandom.hex
        assert_equal key, Sender.(users(:zbig), { idempotency_key: key })
      end

      it 'sends a passed idempotency key' do
        uuid = SecureRandom.uuid
        expect(NotificationCenterChannel).to receive(:broadcast_to).with(uuid, @payload)
        Sender.(uuid, { idempotency_key: 'foobarbaz' })
      end

      it 'sends a generated idempotency key' do
        uuid = SecureRandom.uuid
        expect(SecureRandom).to receive(:hex) { 'foobarbaz' }
        expect(NotificationCenterChannel).to receive(:broadcast_to).with(uuid, @payload)
        Sender.(uuid, {})
      end

      it 'accepts a hash with token' do
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#6', @payload)
        Sender.({ 'token' => 'random-token' }, { idempotency_key: 'foobarbaz' })
      end

      it 'accepts a hash with class' do
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#3', @payload)
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#3.1', @payload)
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#4', @payload)
        Sender.({ 'class' => 'Admin' }, { idempotency_key: 'foobarbaz' })
      end

      it 'sends to a given UUID only once' do
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#1', @payload).once
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('UUID#2', @payload).once

        Sender.([users(:zbig), User], @payload)
      end
    end
  end
end
