# frozen_string_literal: true

require 'loco-rails-core'

require 'loco/broadcaster'
require 'loco/config'
require 'loco/emitter'
require 'loco/engine'
require 'loco/helpers'
require 'loco/hub'
require 'loco/sender'
require 'loco/ws_connection_manager'
require 'loco/ws_connected_resources_manager'
require 'loco/ws_connection_storage'

module Loco
  module_function

  def configure(opts = {})
    Config.configure(opts)
  end
end
