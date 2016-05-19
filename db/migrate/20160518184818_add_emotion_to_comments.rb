class AddEmotionToComments < ActiveRecord::Migration
  def change
    add_column :comments, :emotion, :integer
  end
end
