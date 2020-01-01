# frozen_string_literal: true

json.resources do
  json.array! @articles, partial: 'admin/articles/article_for_list', as: :article
end
json.count @count
