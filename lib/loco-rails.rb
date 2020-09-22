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
require 'loco/ws_connection_manager'
require 'loco/ws_connected_resources_manager'
require 'loco/ws_connection_storage'
require 'loco/jobs/concerns/resource_serializer'

module Loco
  module Jobs
  end

  module_function

  def configure
    Config::CONFIGURATION.new.tap do |config|
      yield config
      Config.configure config
    end
  end
end
