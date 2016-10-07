module Loco
  class Sender
    def initialize recipient, data = {}
      @recipients = [*recipient]
      @data = data
    end

    def emit
      @recipients.each do |recipient|
        NotificationCenterChannel.broadcast_to WsConnectionManager.new(recipient).identifier, @data
      end
    end
  end
end