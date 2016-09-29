module Loco
  class Sender
    def initialize recipient, data = {}
      @recipients = [*recipient]
      @data = data
    end

    def emit
      @recipients.each do |recipient|
        NotificationCenterChannel.broadcast_to serialize_recipient(recipient), @data
      end
    end

    protected

      def serialize_recipient recipient
        if recipient.is_a?(String)
          return recipient
        end
        "#{recipient.class.name.downcase}:#{recipient.id}"
      end
  end
end