# frozen_string_literal: true

module Loco
  class Data
    class << self
      def call(data)
        data ||= {}
        hash = data.except(:idempotency_key)
        hash[:loco] ||= {}
        hash[:loco][:idempotency_key] ||= data[:idempotency_key] || SecureRandom.hex
        hash
      end
    end
  end
end
