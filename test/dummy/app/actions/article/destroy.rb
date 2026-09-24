# frozen_string_literal: true

class Article
  module Destroy
    def self.call(payload, opts)
      user = opts.dig(:ars, :user) || User.find(payload[:user_id])
      article = user.articles.find(payload[:id])
      if article.destroy
        Loco.emit({ event: :destroyed }, subject: article, to: user)
        Result[ok: true, val: { article: }]
      else
        Result[ok: false, val: { article: }]
      end
    end
  end
end
