class AddAdminRateToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :admin_rate, :integer
  end
end
