# frozen_string_literal: true

class Article
  module StartEditing
    def self.call(payload, opts)
      user = opts.dig(:ars, :user) || User.find(payload[:user_id])
      article = user.articles.find(payload[:id])
      mark = Time.current.to_f.to_s
      Loco.emit({ event: :updating, mark: }, subject: article, to: [article.published? ? :all : user])
      Result[ok: true, val: { article:, mark: }]
    end
  end
end
