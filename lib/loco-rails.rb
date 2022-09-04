# frozen_string_literal: true

require 'loco-rails-core'

require 'loco/broadcaster'
require 'loco/config'
require 'loco/emitter'
require 'loco/rails/engine'
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

  def emit(obj, event = nil, opts = {})
    Broadcaster.(
      obj,
      event,
      payload: opts[:payload] || opts[:data],
      recipients: opts[opts[:for] ? :for : :to]
    )
  end

  def emit_to(recipient_s, data)
    Sender.(recipient_s, data)
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
