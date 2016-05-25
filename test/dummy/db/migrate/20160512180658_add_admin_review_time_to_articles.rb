class AddAdminReviewTimeToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :admin_review_time, :float
  end
end
