# frozen_string_literal: true

module Loco
  class Sender
    class << self
      def call(recipient_s, payload)
        recipients = recipient_s.is_a?(Array) ? recipient_s : [recipient_s]
        new.(recipients, Payload.(payload))
      end
    end

    def initialize
      @uuids = []
    end

    def call(recipients, payload)
      recipients.each do |recipient|
        case recipient
        when String then broadcast_to(recipient, payload)
        when Hash then process_hash(recipient, payload)
        else find_and_broadcast_to(recipient, payload)
        end
      end
      payload[:loco][:idempotency_key]
    end

    private

    def process_hash(recipient, payload)
      if recipient.key?('token')
        find_and_broadcast_to(recipient['token'], payload)
      elsif recipient.key?('class')
        find_and_broadcast_to(recipient['class'].constantize, payload)
      end
    end

    def find_and_broadcast_to(recipient, payload)
      WsConnectionFinder.(recipient) do |uuid|
        broadcast_to(uuid, payload)
      end
    end

    def broadcast_to(uuid, payload)
      return if @uuids.include?(uuid)

      @uuids << uuid
      NotificationCenterChannel.broadcast_to(uuid, payload)
    end
  end
end
