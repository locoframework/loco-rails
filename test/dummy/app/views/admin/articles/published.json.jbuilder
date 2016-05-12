json.set! :resources do
  json.array! @articles, partial: 'admin/articles/article_for_list', as: :article
end
json.set! :count, @count