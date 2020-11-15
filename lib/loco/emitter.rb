# frozen_string_literal: true

module Loco
  module Emitter
    def emit(obj, event = nil, opts = {})
      Broadcaster.call(
        obj,
        event,
        payload: opts[:data],
        recipients: opts[opts[:for] ? :for : :to]
      )
    end

    def emit_to(recipient_s, data)
      Sender.call(recipient_s, data)
    end

    def add_hub(name, members = [])
      Hub.set(name, members)
    end

    def get_hub(name)
      Hub.get(name)
    end

    def del_hub(name)
      hub = Hub.get(name)
      return false if hub.nil?

      hub.destroy
    end
  end
end
