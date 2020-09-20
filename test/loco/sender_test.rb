# frozen_string_literal: true

require 'test_helper'

module Loco
  class SenderTest < ActiveSupport::TestCase
    describe '#emit' do
      it 'returns idempotency_key' do
        assert_not_nil Sender.new(users(:zbig), {}).emit
      end
    end
  end
end
