module Loco
  module Emitter
    def emit obj, event = nil, opts = {}
      Broadcaster.new(obj, event, opts).emit
    end
  end
end