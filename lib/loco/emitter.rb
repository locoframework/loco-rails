# frozen_string_literal: true

module Loco
  module Emitter
    def emit(obj, event = nil, opts = {})
      recipient_key = opts[:for] ? :for : :to
      Broadcaster.new.emit(
        obj,
        event,
        payload: opts[:data],
        recipients: opts[recipient_key] ? Array(opts[recipient_key]) : [nil]
      )
    end

    def emit_to(recipient, data)
      Sender.call(recipient, data)
    end

    def add_hub(name, members = [])
      Hub.new(name, members).save
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
