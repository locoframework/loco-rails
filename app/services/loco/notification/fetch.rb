# frozen_string_literal: true

module Loco
  class Notification
    class Fetch
      OVERLAP = 5.seconds

      class << self
        def call(synced_at:, permissions:, recipient_token:, max_size: Loco::Config.notifications_size)
          synced_at = Time.zone.parse(synced_at.to_s)
          permissions = (permissions || []).compact
          notifications = Query::Notification.for_sync(synced_at: synced_at || Time.current, permissions:,
                                                       recipient_token:).first(max_size)
          {
            notifications: notifications.map { Presenter.(_1) },
            synced_at: next_synced_at(notifications, max_size).iso8601(6),
            gap: gap?(synced_at)
          }
        end

        private

        # a short page holds every row up to now, so the sync point moves to the overlap
        # even when nothing was returned — an idle client never drifts into a false `gap`
        def next_synced_at(notifications, max_size)
          if notifications.size == max_size
            notifications.last.updated_at
          else
            OVERLAP.ago
          end
        end

        # rows older than the retention may already be garbage-collected
        def gap?(synced_at)
          retention = Loco::Config.notifications_retention
          !synced_at.nil? && !retention.nil? && synced_at < retention.ago
        end
      end
    end
  end
end
