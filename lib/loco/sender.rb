# frozen_string_literal: true

module Loco
  class Sender
    def initialize(recipient, data = {})
      @recipients = [*recipient]
      @data = data
    end

    def emit
      uuids.each do |uuid|
        NotificationCenterChannel.broadcast_to(uuid, payload)
      end
      payload[:loco][:idempotency_key]
    end

    private

    def uuids
      @recipients.map do |r|
        case r
        when String then r
        when Hub then r.connected_uuids
        else WsConnectionManager.new(r).connected_uuids
        end
      end.flatten.uniq
    end

    def payload
      @data[:loco] ||= {}
      @data[:loco][:idempotency_key] ||= @data[:idempotency_key] || SecureRandom.hex
      @data.delete(:idempotency_key)
      @data
    end
  end
end
