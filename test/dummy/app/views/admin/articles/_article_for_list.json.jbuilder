# frozen_string_literal: true

json.id Ephemeron.used(article).id
json.title truncate(article.title, length: 45, separator: ' ')
json.text truncate(article.text, length: 150, separator: ' ')
json.published_at article.published_at
json.author Ephemeron.used(article.user).try(:username) || '--deleted--'
json.comments_count article.comments.count
