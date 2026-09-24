# frozen_string_literal: true

class Comment
  module Find
    def self.call(payload, opts)
      user = opts.dig(:ars, :user) || (User.find(payload[:user_id]) if payload[:user_id])
      articles = user ? user.articles : Article
      article = articles.find(payload[:article_id])
      Result[ok: true, val: { article:, comment: article.comments.find(payload[:id]) }]
    end
  end
end
