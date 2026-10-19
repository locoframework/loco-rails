# frozen_string_literal: true

# This migration comes from loco (originally 20261014000000)
class AddIdempotencyKeyToLocoNotifications < ActiveRecord::Migration[8.0]
  def change
    add_column :loco_notifications, :idempotency_key, :string
  end
end
