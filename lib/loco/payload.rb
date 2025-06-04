# frozen_string_literal: true

module Loco
  class Payload
    class << self
      def call(payload)
        hash = payload ? payload.clone : {}
        hash[:loco] ||= {}
        hash[:loco][:idempotency_key] ||= hash[:idempotency_key] || SecureRandom.hex
        hash.delete(:idempotency_key)
        hash
      end
    end
  end
end
