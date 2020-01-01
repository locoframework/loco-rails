# frozen_string_literal: true

if @abbr
  json.partial! 'main/articles/article_for_list', article: @article
else
  json.partial! 'main/articles/article', article: @article
end
