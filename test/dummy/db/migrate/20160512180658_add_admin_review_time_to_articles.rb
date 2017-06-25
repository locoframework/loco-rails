class AddAdminReviewTimeToArticles < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :admin_review_time, :float
  end
end
