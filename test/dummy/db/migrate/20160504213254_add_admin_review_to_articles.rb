class AddAdminReviewToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :admin_review, :text
  end
end
