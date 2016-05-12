class AddAdminReviewToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :admin_review, :text
  end
end
