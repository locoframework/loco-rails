# frozen_string_literal: true

module Loco
  module Query
    class Notification
      class << self
        # index: index_loco_notifications_on_updated_at_and_recipient,
        #        index_loco_notifications_on_updated_at_and_recipient_token
        def for_sync(synced_at:, permissions:, recipient_token:)
          recipients = [Loco::Notification.to_all, *permissions.map { Loco::Notification.to_resource(_1) }]
          recipients << Loco::Notification.to_token(recipient_token) if recipient_token
          Loco::Notification.updated_after(synced_at).and(recipients.reduce(:or)).order(:updated_at)
        end
      end
    end
  end
end
