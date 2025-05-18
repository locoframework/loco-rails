# frozen_string_literal: true

require 'loco/broadcaster'
require 'loco/config'
require 'loco/rails/engine'
require 'loco/hub'
require 'loco/permissions_presenter'
require 'loco/sender'
require 'loco/ws_connection_checker'
require 'loco/ws_connection_manager'
require 'loco/ws_connection_finder'
require 'loco/ws_connection_identifier'
require 'loco/ws_connection_storage'

module Loco
  module Priv
    module_function

    def new_emit(payload, to:, ws_only:, subject: nil)
      return Sender.(to, payload) if ws_only

      event = payload.delete(:event)
      Broadcaster.(subject, event, payload:, recipients: to)
    end
  end

  module_function

  def configure
    Config::CONFIGURATION.new.tap do |config|
      yield config
      Config.configure config
    end
  end

  def emit(subject_or_payload, event = nil, payload: nil, data: nil, for: nil, to: nil,
           subject: nil, ws_only: false)
    recipient = binding.local_variable_get(:for)
    if subject_or_payload.is_a?(ActiveRecord::Base)
      payload = (payload || data || {}).merge(event:)
      Priv.new_emit(payload, to: to || recipient, ws_only:, subject: subject_or_payload)
    else
      Priv.new_emit(subject_or_payload, to:, ws_only:, subject:)
    end
  end

  def emit_to(recipient_s, payload)
    Priv.new_emit(payload, to: recipient_s, ws_only: true)
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
