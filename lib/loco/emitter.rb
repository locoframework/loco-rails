# frozen_string_literal: true

# TODO: remove in v7
module Loco
  module Emitter
    def emit(obj, event = nil, opts = {})
      Loco.emit(obj, event, opts)
    end

    def emit_to(recipient_s, data)
      Loco.emit_to(recipient_s, data)
    end

    def add_hub(name, members = [])
      Loco.add_hub(name, members)
    end

    def get_hub(name)
      Loco.get_hub(name)
    end

    def del_hub(name)
      Loco.del_hub(name)
    end
  end
end
