# frozen_string_literal: true

class AddIdempotencyKeyToLocoNotifications < ActiveRecord::Migration[8.0]
  def change
    add_column :loco_notifications, :idempotency_key, :string
  end
end
