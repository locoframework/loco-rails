# frozen_string_literal: true

module Loco
  class NotificationCenter
    include Emitter

    def received_message(permissions, data)
      # handle messages here
    end
  end
end
