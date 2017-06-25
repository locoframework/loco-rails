class AddEmotionToComments < ActiveRecord::Migration[4.2]
  def change
    add_column :comments, :emotion, :integer
  end
end
