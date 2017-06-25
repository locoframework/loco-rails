class AddAdminRateToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :admin_rate, :integer
  end
end
