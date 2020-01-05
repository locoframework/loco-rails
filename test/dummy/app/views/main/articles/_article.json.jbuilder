# frozen_string_literal: true

json.id Ephemeron.used(article).id
json.title article.title
json.text article.text
json.published_at article.published_at
json.author Ephemeron.used(article.user).username
json.comments_count article.comments.count
