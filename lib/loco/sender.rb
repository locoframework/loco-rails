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
      @data[:loco][:idempotency_key]
    end

    private

    def uuids
      @recipients.map do |r|
        if r.is_a? String
          r
        elsif r.is_a? Hub
          recipients_from_hub r
        else
          WsConnectionManager.new(r).connected_uuids
        end
      end.flatten.uniq
    end

    def recipients_from_hub(hub)
      hub.raw_members.map do |m|
        WsConnectionManager.new(m).connected_uuids
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
