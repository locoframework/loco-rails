# frozen_string_literal: true

module Loco
  class Sender
    class << self
      def call(recipient_s, payload = {})
        # flatten.uniq - test it!
        payload = with_idempotency_key(payload)
        Array(recipient_s).each do |recipient|
          case recipient
          when String then NotificationCenterChannel.broadcast_to(recipient, payload)
          when Hash then broadcast_to(recipient['token'], payload)
          when Hub then send_to_hub(recipient, payload)
          else
            broadcast_to(recipient, payload)
          end
        end
        payload[:loco][:idempotency_key]
      end

      private

      def with_idempotency_key(hash)
        hash = hash.clone
        hash[:loco] ||= {}
        hash[:loco][:idempotency_key] ||= hash[:idempotency_key] || SecureRandom.hex
        hash.delete(:idempotency_key)
        hash
      end

      def send_to_hub(recipient, payload)
        recipient.connected_uuids.each do |uuid|
          NotificationCenterChannel.broadcast_to(uuid, payload)
        end
      end

      def broadcast_to(recipient, payload)
        WsConnectionFinder.call(recipient) do |uuid, _|
          NotificationCenterChannel.broadcast_to(uuid, payload)
        end
      end
    end
  end
end
