class AddAdminRateToComments < ActiveRecord::Migration[4.2]
  def change
    add_column :comments, :admin_rate, :integer
  end
end
