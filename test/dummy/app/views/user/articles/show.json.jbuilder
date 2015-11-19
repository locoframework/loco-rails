if @abbr
  json.partial! 'user/articles/article_for_list', article: @article
else
  json.partial! 'user/articles/article', article: @article
end