# frozen_string_literal: true

class Article
  module Publish
    def self.call(payload, opts)
      user = opts.dig(:ars, :user) || User.find(payload[:user_id])
      article = user.articles.find(payload[:id])
      return Result[ok: false, val: { article: }] unless article.publish

      Loco.emit({ event: :published }, subject: article)
      Loco.emit({ event: :updated }, subject: article, to: user)
      Result[ok: true, val: { article: }]
    end
  end
end
