module Loco
  module Emitter
    def emit obj, event = nil, opts = {}
      Broadcaster.new(obj, event, opts).emit
    end

    def emit_to recipient, data
      serialized_recipient = if recipient.is_a?(String)
        recipient
      else
        "#{recipient.class.name.downcase}:#{recipient.id}"
      end
      NotificationCenterChannel.broadcast_to serialized_recipient, data
    end
  end
end