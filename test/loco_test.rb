# frozen_string_literal: true

require 'test_helper'

class LocoTest < TCWithMocks
  test 'truth' do
    assert_kind_of Module, Loco
  end

  # `event`, `type` and `idempotency_key` are lifted out of the payload,
  # the rest travels under `payload`
  describe 'emit — the shape of the emitted data' do # rubocop:disable Metrics/BlockLength
    it 'generates an idempotency key when none is given' do
      expect(SecureRandom).to receive(:hex).and_return('generated')
      expect(Loco::NotificationCenterChannel).to receive(:broadcast_to).with(
        'uuid1', { payload: { foo: 'bar' }, type: nil, loco: { idempotency_key: 'generated' } }
      )
      Loco.emit({ foo: 'bar' }, to: 'uuid1', ws_only: true)
    end

    it 'uses a passed idempotency key and returns it' do
      expect(Loco::NotificationCenterChannel).to receive(:broadcast_to).with(
        'uuid1', { payload: {}, type: 'PING', loco: { idempotency_key: 'given' } }
      )
      key = Loco.emit({ type: 'PING', idempotency_key: 'given' }, to: 'uuid1', ws_only: true)
      assert_equal 'given', key
    end

    it 'keeps the event out of the payload and passes it to the broadcaster' do
      Loco.emit({ event: :created, foo: 'bar' }, subject: articles(:one), to: 'tok')
      notification = Loco::Notification.order(:created_at).last
      assert_equal 'created', notification.event
      assert_equal({ 'foo' => 'bar' }, notification.data['payload'].except('id'))
      assert notification.data['loco']['idempotency_key']
    end

    it 'does not mutate the passed payload' do
      payload = { type: 'PING', idempotency_key: 'given', foo: 'bar' }
      Loco.emit(payload, to: 'uuid1', ws_only: true)
      assert_equal({ type: 'PING', idempotency_key: 'given', foo: 'bar' }, payload)
    end
  end
end
