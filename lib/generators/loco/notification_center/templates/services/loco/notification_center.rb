module Loco
  class NotificationCenter
    include Emitter

    def received_signal permissions, data
      # handle signals here
    end
  end
end