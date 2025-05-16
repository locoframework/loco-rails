# frozen_string_literal: true

class DropConnections < ActiveRecord::Migration[7.2]
  def change
    drop_table :connections
  end
end
