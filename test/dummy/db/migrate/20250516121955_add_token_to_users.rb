# frozen_string_literal: true

class AddTokenToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :token, :string
    add_index  :users, :token, unique: true, name: 'index_users_on_token'
  end
end
