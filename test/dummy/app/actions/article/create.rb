# frozen_string_literal: true

class Article
  module Create
    def self.call(payload, opts)
      user = opts.dig(:ars, :user) || User.find(payload[:user_id])
      article = user.articles.new(payload[:article])
      if article.save
        Loco.emit({ event: :created }, subject: article, to: user)
        Result[ok: true, val: { article: }]
      else
        Result[ok: false, val: { article: }]
      end
    end
  end
end
