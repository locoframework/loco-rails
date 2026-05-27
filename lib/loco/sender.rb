# frozen_string_literal: true

module Loco
  class Sender
    def initialize(recipient_s)
      @recipients = recipient_s.is_a?(Array) ? recipient_s : [recipient_s]
      @uuids = []
    end

    def call(data)
      @recipients.each do |recipient|
        case recipient
        when String then broadcast_to(recipient, data)
        when Hash then process_hash(recipient, data)
        else find_and_broadcast_to(recipient, data)
        end
      end
      data[:loco][:idempotency_key]
    end

    private

    def process_hash(recipient, data)
      if recipient.key?('token')
        find_and_broadcast_to(recipient['token'], data)
      elsif recipient.key?('class')
        find_and_broadcast_to(recipient['class'].constantize, data)
      end
    end

    def find_and_broadcast_to(recipient, data)
      WsConnectionFinder.(recipient) do |uuid|
        broadcast_to(uuid, data)
      end
    end

    def broadcast_to(uuid, data)
      return if @uuids.include?(uuid)

      @uuids << uuid
      NotificationCenterChannel.broadcast_to(uuid, data)
    end
  end
end
