require "loco/engine"
require "loco/helpers"
require "loco/config"
require "loco/broadcaster"
require "loco/emitter"

module Loco
  if Rails.version.to_f < 5
    class ApplicationCable
      class Channel
      end
    end
  end
end
