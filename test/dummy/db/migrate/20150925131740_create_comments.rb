class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :author
      t.text :text
      t.integer :article_id

      t.timestamps null: false, limit: 6
    end
  end
end
