# frozen_string_literal: true

class CreateLocoNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :loco_notifications, id: false do |t|
      t.string :obj_class
      t.bigint :obj_id
      t.string :event
      t.column :data, connection.adapter_name == 'PostgreSQL' ? :jsonb : :json
      t.string :recipient_class
      t.bigint :recipient_id
      t.string :recipient_token

      t.timestamps null: false, limit: 6
    end
  end
end
