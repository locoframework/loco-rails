if @abbr
  json.partial! 'admin/articles/article_for_list', article: @article
else
  json.partial! 'admin/articles/article', article: @article
end