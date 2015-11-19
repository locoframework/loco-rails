json.set! :resources do
  json.array! @articles, partial: 'main/articles/article_for_list', as: :article
end
json.set! :count, @count