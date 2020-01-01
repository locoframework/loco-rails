# frozen_string_literal: true

json.id article.id
json.title truncate(article.title, length: 25, separator: ' ')
json.text truncate(article.text, length: 75, separator: ' ')
json.created_at article.created_at
json.updated_at article.updated_at
json.published_at article.published_at
json.comments_count article.comments.count
