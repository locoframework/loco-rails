# frozen_string_literal: true

require 'loco-rails-core'

require 'loco/broadcaster'
require 'loco/config'
require 'loco/emitter'
require 'loco/engine'
require 'loco/helpers'
require 'loco/hub'
require 'loco/permissions_presenter'
require 'loco/sender'
require 'loco/ws_connection_checker'
require 'loco/ws_connection_manager'
require 'loco/ws_connection_finder'
require 'loco/ws_connection_identifier'
require 'loco/ws_connection_storage'

module Loco
  module_function

  def configure
    Config::CONFIGURATION.new.tap do |config|
      yield config
      Config.configure config
    end
  end
end
