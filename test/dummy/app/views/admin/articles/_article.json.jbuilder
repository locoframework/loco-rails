# frozen_string_literal: true

json.id article.id
json.title article.title
json.text article.text
json.created_at article.created_at
json.updated_at article.updated_at
json.published_at article.published_at
json.author article.user.username
json.comments_count article.comments.count
json.admin_review article.admin_review
json.category_id article.category_id
json.admin_rate article.admin_rate
