# frozen_string_literal: true

require 'loco/broadcaster'
require 'loco/config'
require 'loco/rails/engine'
require 'loco/hub'
require 'loco/payload'
require 'loco/permissions'
require 'loco/permissions_presenter'
require 'loco/sender'
require 'loco/ws_connection_checker'
require 'loco/ws_connection_manager'
require 'loco/ws_connection_finder'
require 'loco/ws_connection_identifier'
require 'loco/ws_connection_storage'

module Loco
  module Priv
    def self.new_emit(payload, to:, ws_only:, subject: nil)
      return Sender.(to, payload) if ws_only

      event = payload.delete(:event)
      Broadcaster.(subject, event, payload:, recipients: to)
    end
  end

  class << self
    def configure
      Config::CONFIGURATION.new.tap do |config|
        yield config
        Config.configure config
      end
    end

    def emit(subject_or_payload, event = nil, payload: nil, data: nil, for: nil, to: nil, # rubocop:disable Metrics/MethodLength
             subject: nil, ws_only: false)
      to ||= binding.local_variable_get(:for)
      if subject_or_payload.is_a?(ActiveRecord::Base)
        ActiveSupport::Deprecation.new('8.0', 'Loco-Rails').warn(
          'Positional `Loco.emit(subject, event, payload:, to:)` is deprecated. ' \
          'Use `Loco.emit(payload, subject:, to:)` with `event:` inside the payload hash.'
        )
        payload = (payload || data || {}).merge(event:)
        Priv.new_emit(payload, to:, ws_only:, subject: subject_or_payload)
      else
        if data
          ActiveSupport::Deprecation.new('8.0', 'Loco-Rails').warn(
            '`data:` keyword is deprecated. Pass the payload as the first positional argument.'
          )
        end
        if binding.local_variable_get(:for)
          ActiveSupport::Deprecation.new('8.0', 'Loco-Rails').warn(
            '`for:` keyword is deprecated. Use `to:` instead.'
          )
        end
        Priv.new_emit(subject_or_payload, to:, ws_only:, subject:)
      end
    end

    def emit_to(recipient_s, payload)
      ActiveSupport::Deprecation.new('8.0', 'Loco-Rails').warn(
        '`Loco.emit_to(recipients, payload)` is deprecated. ' \
        'Use `Loco.emit(payload, to: recipients, ws_only: true)` instead.'
      )
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
end
