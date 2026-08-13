# frozen_string_literal: true

require 'loco/broadcaster'
require 'loco/config'
require 'loco/rails/engine'
require 'loco/hub'
require 'loco/permissions'
require 'loco/permissions_presenter'
require 'loco/sender'
require 'loco/ws_connection_manager'
require 'loco/ws_connection_finder'
require 'loco/ws_connection_identifier'
require 'loco/ws_connection_storage'

module Loco
  DEPRECATOR = ActiveSupport::Deprecation.new('8.0', 'Loco-Rails')

  class << self
    def configure
      yield Config
    end

    def emit(subject_or_payload, event = nil, payload: nil, data: nil, for: nil, to: nil,
             subject: nil, ws_only: false)
      for_arg = binding.local_variable_get(:for)
      to ||= for_arg
      DEPRECATOR.warn('`for:` keyword is deprecated. Use `to:` instead.') if for_arg
      return new_emit(subject_or_payload, to:, ws_only:, subject:) unless subject_or_payload.is_a?(ActiveRecord::Base)

      DEPRECATOR.warn(
        'Positional `Loco.emit(subject, event, payload:, to:)` is deprecated. ' \
        'Use `Loco.emit(payload, subject:, to:)` with `event:` inside the payload hash.'
      )
      new_emit((payload || data || {}).merge(event:), to:, ws_only:, subject: subject_or_payload)
    end

    def emit_to(recipient_s, payload)
      DEPRECATOR.warn(
        '`Loco.emit_to(recipients, payload)` is deprecated. ' \
        'Use `Loco.emit(payload, to: recipients, ws_only: true)` instead.'
      )
      new_emit(payload, to: recipient_s, ws_only: true)
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

    private

    def new_emit(payload, to:, ws_only:, subject: nil)
      data = {
        payload: payload.except(:event, :type, :idempotency_key),
        type: payload[:type],
        loco: { idempotency_key: payload[:idempotency_key] || SecureRandom.hex }
      }
      return Sender.new(to).(data) if ws_only

      Broadcaster.(subject, payload[:event], data:, recipients: to)
    end
  end
end
