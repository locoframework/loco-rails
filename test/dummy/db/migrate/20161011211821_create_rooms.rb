# frozen_string_literal: true

class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.string :name

      t.timestamps limit: 6
    end
  end
end
