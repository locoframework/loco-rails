# frozen_string_literal: true

class Comment
  module Find
    def self.call(payload)
      articles = payload[:user] ? payload[:user].articles : Article
      article = articles.find(payload[:article_id])
      Result[ok: true, val: { article:, comment: article.comments.find(payload[:id]) }]
    end
  end
end
