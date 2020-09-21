# frozen_string_literal: true

require 'test_helper'

module Loco
  class SenderTest < TCWithMocks
    describe '.call' do
      it 'does not mutate a passed payload' do
        payload = { foo: 'bar' }
        Sender.call('foobarbaz', payload)
        assert_equal({ foo: 'bar' }, payload)
      end

      it 'returns idempotency_key' do
        key = SecureRandom.hex
        assert_equal key, Sender.call(users(:zbig), { idempotency_key: key })
      end

      it 'sends a passed idempotency key' do
        uuid = SecureRandom.uuid
        key = SecureRandom.hex
        payload = { loco: { idempotency_key: key } }
        expect(NotificationCenterChannel).to receive(:broadcast_to).with(uuid, payload)
        Sender.call(uuid, { idempotency_key: key })
      end

      it 'sends a generated idempotency key' do
        uuid = SecureRandom.uuid
        expect(SecureRandom).to receive(:hex) { 'foobarbaz' }
        payload = { loco: { idempotency_key: 'foobarbaz' } }
        expect(NotificationCenterChannel).to receive(:broadcast_to).with(uuid, payload)
        Sender.call(uuid, {})
      end
    end
  end
end
