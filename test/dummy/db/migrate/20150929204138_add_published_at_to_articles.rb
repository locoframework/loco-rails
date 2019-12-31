# frozen_string_literal: true

class AddPublishedAtToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :published_at, :datetime
  end
end
