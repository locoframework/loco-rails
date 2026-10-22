# frozen_string_literal: true

# This migration comes from loco (originally 20261022000000)
class IndexLocoNotificationsOnUpdatedAt < ActiveRecord::Migration[8.0]
  def change
    remove_index :loco_notifications, %i[created_at recipient_class recipient_id],
                 name: 'index_loco_notifications_on_created_at_and_recipient'
    remove_index :loco_notifications, %i[created_at recipient_token],
                 name: 'index_loco_notifications_on_created_at_and_recipient_token'
    add_index :loco_notifications, %i[updated_at recipient_class recipient_id],
              name: 'index_loco_notifications_on_updated_at_and_recipient'
    add_index :loco_notifications, %i[updated_at recipient_token],
              name: 'index_loco_notifications_on_updated_at_and_recipient_token'
    add_index :loco_notifications, %i[idempotency_key recipient_class],
              name: 'index_loco_notifications_on_idempotency_key_and_recipient_class'
  end
end
