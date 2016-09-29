module Loco
  module Emitter
    def emit obj, event = nil, opts = {}
      Broadcaster.new(obj, event, opts).emit
    end

    def emit_to recipient, data
      Sender.new(recipient, data).emit
    end
  end
end