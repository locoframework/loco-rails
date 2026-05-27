# frozen_string_literal: true

module Loco
  class Data
    class << self
      def call(data)
        data ||= {}
        new_data = data.except(:idempotency_key)
        new_data[:loco] ||= {}
        new_data[:loco][:idempotency_key] ||= data[:idempotency_key] || SecureRandom.hex
        new_data
      end
    end
  end
end
