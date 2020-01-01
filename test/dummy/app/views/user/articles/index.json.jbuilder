# frozen_string_literal: true

json.resources do
  json.array! Ephemeron.used(@articles), partial: 'user/articles/article_for_list', as: :article
end
json.count @count
