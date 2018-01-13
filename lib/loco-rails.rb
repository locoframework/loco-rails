# frozen_string_literal: true

require "loco/engine"
require "loco/helpers"
require "loco/config"
require "loco/broadcaster"
require "loco/sender"
require "loco/emitter"
require "loco/ws_connection_storage"
require "loco/ws_connection_manager"
require "loco/ws_connected_resources_manager"
require "loco/hub"

module Loco
  if Rails.version.to_f < 5
    class ApplicationCable
      class Channel
      end
    end
  end
end
