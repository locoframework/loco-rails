class AddAdminRateToComments < ActiveRecord::Migration
  def change
    add_column :comments, :admin_rate, :integer
  end
end
