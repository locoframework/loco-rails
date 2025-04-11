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

    # TODO: implement
    def new_emit(payload, opts)
      Sender.(opts[:to], payload)
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
           subject: nil, to: nil, ws_only: nil)
    if to && ws_only
      Priv.new_emit(for_or_recipients_or_payload, { to:, ws_only: })
    elsif for_or_recipients_or_payload.is_a?(Hash) && for_or_recipients_or_payload[:event]
      event = for_or_recipients_or_payload.delete(:event)
      Priv.legacy_emit(subject, event, { to:, payload: for_or_recipients_or_payload })
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
