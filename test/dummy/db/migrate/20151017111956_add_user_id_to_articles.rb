# frozen_string_literal: true

class AddUserIdToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :user_id, :integer
  end
end
