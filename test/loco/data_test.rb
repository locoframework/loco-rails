# frozen_string_literal: true

require 'test_helper'

module Loco
  class DataTest < TCWithMocks
    describe '.call' do
      it 'generates an idempotency key when none is given' do
        expect(SecureRandom).to receive(:hex).and_return('generated')
        assert_equal({ loco: { idempotency_key: 'generated' } }, Data.({}))
      end

      it 'uses a passed idempotency key' do
        assert_equal({ loco: { idempotency_key: 'given' } }, Data.(idempotency_key: 'given'))
      end

      it 'moves idempotency_key under loco and drops the top-level key' do
        result = Data.(type: 'X', idempotency_key: 'given')
        assert_equal({ type: 'X', loco: { idempotency_key: 'given' } }, result)
      end

      it 'keeps an existing loco idempotency_key' do
        result = Data.(loco: { idempotency_key: 'kept' })
        assert_equal({ loco: { idempotency_key: 'kept' } }, result)
      end

      it 'does not mutate the passed hash' do
        original = { idempotency_key: 'given' }
        Data.(original)
        assert_equal({ idempotency_key: 'given' }, original)
      end

      it 'handles nil' do
        expect(SecureRandom).to receive(:hex).and_return('generated')
        assert_equal({ loco: { idempotency_key: 'generated' } }, Data.(nil))
      end
    end
  end
end
