# frozen_string_literal: true

class Query
  class Comment
    def initialize(articles)
      @articles = articles
    end

    def find(article_id:, id:)
      article = @articles.find(article_id)
      { article:, comment: article.comments.find(id) }
    end
  end
end
