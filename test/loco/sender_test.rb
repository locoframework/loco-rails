# frozen_string_literal: true

require 'test_helper'

module Loco
  class SenderTest < TCWithMocks
    include WsHelpers

    describe '.call' do
      before do
        @payload = { loco: { idempotency_key: 'foobarbaz' } }
      end

      it 'sends payload via WS to recipients' do
        create_connection(users(:zbig), 'u12345')
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('random_uuid', @payload)
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('u12345', @payload)
        Sender.call([users(:zbig), 'random_uuid'], { idempotency_key: 'foobarbaz' })
      end

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
        expect(NotificationCenterChannel).to receive(:broadcast_to).with(uuid, @payload)
        Sender.call(uuid, { idempotency_key: 'foobarbaz' })
      end

      it 'sends a generated idempotency key' do
        uuid = SecureRandom.uuid
        expect(SecureRandom).to receive(:hex) { 'foobarbaz' }
        expect(NotificationCenterChannel).to receive(:broadcast_to).with(uuid, @payload)
        Sender.call(uuid, {})
      end

      it 'accepts a hash with token' do
        create_connection('random-token', 'u12345')
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('u12345', @payload)
        Sender.call({ 'token' => 'random-token' }, { idempotency_key: 'foobarbaz' })
      end

      it 'accepts a hash with class' do
        create_connection(admins(:one), 'u12345')
        create_connection(admins(:two), 'u22345')
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('u12345', @payload)
        expect(NotificationCenterChannel).to receive(:broadcast_to).with('u22345', @payload)
        Sender.call({ 'class' => 'Admin' }, { idempotency_key: 'foobarbaz' })
      end
    end
  end
end
