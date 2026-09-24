# frozen_string_literal: true

class Article
  module Review
    def self.call(payload)
      article = Article.find(payload[:id])
      Result[ok: article.update(payload[:article]), val: { article: }]
    end
  end
end
