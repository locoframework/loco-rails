# frozen_string_literal: true

class CreateArticles < ActiveRecord::Migration[4.2]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :text

      t.timestamps null: false, limit: 6
    end
  end
end
