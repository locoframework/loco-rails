# frozen_string_literal: true

module Loco
  class Notification
    class Presenter
      class << self
        def call(notification)
          idempotency_key, type, payload = wire_fields(notification)
          {
            loco: {
              idempotency_key:,
              sync_time: sync_time(notification)&.iso8601(6)
            },
            type:,
            payload:,
            obj_class: notification.obj_class,
            obj_id: notification.obj_id
          }
        end

        private

        def sync_time(notification)
          notification.created_at && (notification.created_at - Fetcher::OVERLAP) # nil when `ws_only`
        end

        # ponytail: rows written before the idempotency_key column keep the key, the
        # type and the payload inside `data` — drop the else branch once they're GC'd
        # TODO: v8
        def wire_fields(notification)
          stored = notification.data || {}
          if notification.idempotency_key
            [notification.idempotency_key, notification.event, stored]
          else
            payload = stored.fetch('payload') { stored.except('loco') }
            [stored.dig('loco', 'idempotency_key'), notification.event || stored['type'], payload]
          end
        end
      end
    end
  end
end
