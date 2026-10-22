# frozen_string_literal: true

module Loco
  class Notification
    class Fetch
      OVERLAP = 5.seconds

      class << self
        def call(synced_at:, permissions:, recipient_token:, max_size: Loco::Config.notifications_size)
          synced_at = Time.zone.parse(synced_at.to_s) || Time.current
          permissions = (permissions || []).compact
          notifications = Query::Notification.for_sync(synced_at:, permissions:, recipient_token:).first(max_size)
          {
            notifications: notifications.map { Presenter.(_1) },
            synced_at: next_synced_at(notifications, synced_at, max_size).iso8601(6)
          }
        end

        private

        def next_synced_at(notifications, synced_at, max_size)
          if notifications.size == max_size
            notifications.last.updated_at
          else
            [notifications.last&.updated_at || synced_at, OVERLAP.ago].min
          end
        end
      end
    end
  end
end
