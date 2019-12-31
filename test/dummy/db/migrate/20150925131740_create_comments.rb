# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[4.2]
  def change
    create_table :comments do |t|
      t.string :author
      t.text :text
      t.integer :article_id

      t.timestamps null: false, limit: 6
    end
  end
end
