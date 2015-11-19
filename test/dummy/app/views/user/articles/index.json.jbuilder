json.set! :resources do
  json.array! @articles, partial: 'user/articles/article_for_list', as: :article
end
json.set! :count, @count