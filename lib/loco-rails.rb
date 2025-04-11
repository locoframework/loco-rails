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

    def legacy_emit(obj, event, opts)
      Broadcaster.(
        obj,
        event,
        payload: opts[:payload] || opts[:data],
        recipients: opts[opts[:for] ? :for : :to]
      )
    end
  end

  module_function

  def configure
    Config::CONFIGURATION.new.tap do |config|
      yield config
      Config.configure config
    end
  end

  def emit(for_or_recipients_or_payload = nil, event_or_payload = nil, payload: nil, data: nil, for: nil,
           to: nil, subject: nil, ws_only: false)
    if (to && ws_only) || (for_or_recipients_or_payload.is_a?(Hash) && for_or_recipients_or_payload[:event])
      Priv.new_emit(for_or_recipients_or_payload, to:, subject:, ws_only:)
    else
      opts = { payload:, data:, for:, to: }
      Priv.legacy_emit(for_or_recipients_or_payload, event_or_payload, opts)
    end
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
