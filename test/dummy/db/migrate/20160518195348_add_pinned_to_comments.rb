class AddPinnedToComments < ActiveRecord::Migration[4.2]
  def change
    add_column :comments, :pinned, :boolean
  end
end
