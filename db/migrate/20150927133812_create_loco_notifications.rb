class CreateLocoNotifications < ActiveRecord::Migration
  def change
    create_table :loco_notifications do |t|
      t.string :obj_class
      t.integer :obj_id
      t.string :event
      t.string :data
      t.string :recipient_class
      t.integer :recipient_id
      t.string :recipient_token

      t.timestamps null: false
    end
  end
end
