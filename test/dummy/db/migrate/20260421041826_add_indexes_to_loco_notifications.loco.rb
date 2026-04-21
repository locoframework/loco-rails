# frozen_string_literal: true

# This migration comes from loco (originally 20240211210452)
class AddIndexesToLocoNotifications < ActiveRecord::Migration[7.1]
  def change
    add_index :loco_notifications, %i[created_at recipient_class recipient_id],
              name: 'index_loco_notifications_on_created_at_and_recipient'

    add_index :loco_notifications, %i[created_at recipient_token],
              name: 'index_loco_notifications_on_created_at_and_recipient_token'
  end
end
