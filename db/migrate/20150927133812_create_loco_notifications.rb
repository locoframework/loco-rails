# frozen_string_literal: true

class CreateLocoNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :loco_notifications, id: false do |t|
      t.string :obj_class
      t.bigint :obj_id
      t.string :event
      t.column :data, (ActiveRecord::Base.connection.adapter_name == 'PostgreSQL' ? :jsonb : :text)
      t.string :recipient_class
      t.bigint :recipient_id
      t.string :recipient_token

      t.timestamps null: false, limit: 6
    end
  end
end
