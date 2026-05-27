# frozen_string_literal: true

module Loco
  class Data
    class << self
      def call(data)
        hash = data ? data.clone : {}
        hash[:loco] ||= {}
        hash[:loco][:idempotency_key] ||= hash[:idempotency_key] || SecureRandom.hex
        hash.delete(:idempotency_key)
        hash
      end
    end
  end
end
