# frozen_string_literal: true

class Article
  module Update
    def self.call(payload, opts)
      user = opts.dig(:ars, :user) || User.find(payload[:user_id])
      article = user.articles.find(payload[:id])
      if article.update(payload[:article])
        Loco.emit({ event: :updated }, subject: article, to: [article.published? ? :all : user])
        Result[ok: true, val: { article: }]
      else
        Result[ok: false, val: { article: }]
      end
    end
  end
end
