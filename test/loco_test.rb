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
        'uuid1',
        ws_message(type: 'PING', payload: { 'foo' => 'bar' }, key: 'generated')
      )
      assert_equal 'generated', Loco.emit({ type: 'PING', foo: 'bar' }, to: 'uuid1', ws_only: true)
    end

    # the client drops the copies one emit produces — every row must carry the same key
    it 'shares one idempotency key across all rows of an emit' do
      key = Loco.emit({ event: :created }, subject: articles(:one), to: [users(:zbig), User, 'tok'])
      assert_equal [key], Loco::Notification.distinct.pluck(:idempotency_key)
      assert_equal 3, Loco::Notification.count
    end

    it 'requires the message to be named' do
      assert_raises(ArgumentError) { Loco.emit({ foo: 'bar' }, to: 'uuid1', ws_only: true) }
      assert_raises(ArgumentError) { Loco.emit({ foo: 'bar' }, subject: articles(:one), to: 'tok') }
      assert_raises(ArgumentError) { Loco.emit_to('uuid1', { foo: 'bar' }) }
    end

    it 'uses a passed idempotency key and returns it' do
      expect(Loco::NotificationCenterChannel).to receive(:broadcast_to).with(
        'uuid1', ws_message(type: 'PING', payload: {}, key: 'given')
      )
      key = Loco.emit({ type: 'PING', idempotency_key: 'given' }, to: 'uuid1', ws_only: true)
      assert_equal 'given', key
    end

    it 'keeps the event out of the payload and passes it to the broadcaster' do
      key = Loco.emit({ event: :created, foo: 'bar' }, subject: articles(:one), to: 'tok')
      notification = Loco::Notification.order(:created_at).last
      assert_equal 'created', notification.event
      assert_equal({ 'foo' => 'bar' }, notification.data)
      assert_equal key, notification.idempotency_key
    end

    it 'delivers only once the surrounding transaction commits' do
      ActiveRecord::Base.transaction do
        Loco.emit({ event: :created }, subject: articles(:one), to: 'tok')
        assert_equal 0, Loco::Notification.count
      end
      assert_equal 1, Loco::Notification.count
    end

    it 'never delivers an emit whose transaction rolls back' do
      expect(Loco::NotificationCenterChannel).not_to receive(:broadcast_to)
      ActiveRecord::Base.transaction do
        Loco.emit({ type: 'PING' }, to: 'uuid1', ws_only: true)
        Loco.emit({ event: :created }, subject: articles(:one), to: 'tok')
        raise ActiveRecord::Rollback
      end
      assert_equal 0, Loco::Notification.count
    end

    it 'does not mutate the passed payload' do
      payload = { type: 'PING', idempotency_key: 'given', foo: 'bar' }
      Loco.emit(payload, to: 'uuid1', ws_only: true)
      assert_equal({ type: 'PING', idempotency_key: 'given', foo: 'bar' }, payload)
    end

    # ws_only has the same shape as a persisted notification — an unsaved one:
    # no subject, no place on the clock
    def ws_message(type:, payload:, key:)
      { loco: { idempotency_key: key, sync_time: nil }, type:, payload:, obj_class: nil, obj_id: nil }
    end
  end
end
