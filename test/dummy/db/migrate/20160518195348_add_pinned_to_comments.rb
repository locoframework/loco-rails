class AddPinnedToComments < ActiveRecord::Migration
  def change
    add_column :comments, :pinned, :boolean
  end
end
