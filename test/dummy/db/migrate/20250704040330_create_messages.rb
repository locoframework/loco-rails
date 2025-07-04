# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.bigint :room_id, null: false
      t.bigint :user_id, null: false
      t.text :content, null: false

      t.timestamps
    end

    add_index :messages, :user_id
    add_index :messages, %i[room_id created_at]
  end
end
