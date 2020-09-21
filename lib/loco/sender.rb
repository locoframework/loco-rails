# frozen_string_literal: true

module Loco
  class Sender
    class << self
      def call(recipient, payload = {})
        payload = with_idempotency_key(payload)
        uuids([*recipient]).each do |uuid|
          NotificationCenterChannel.broadcast_to(uuid, payload)
        end
        payload[:loco][:idempotency_key]
      end

      private

      def uuids(recipients)
        recipients.map do |r|
          case r
          when String then r
          when Hub then r.connected_uuids
          else WsConnectionManager.new(r).connected_uuids
          end
        end.flatten.uniq
      end

      def with_idempotency_key(hash)
        hash = hash.clone
        hash[:loco] ||= {}
        hash[:loco][:idempotency_key] ||= hash[:idempotency_key] || SecureRandom.hex
        hash.delete(:idempotency_key)
        hash
      end
    end
  end
end
