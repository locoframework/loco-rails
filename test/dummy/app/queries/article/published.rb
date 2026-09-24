# frozen_string_literal: true

class Article
  module Published
    def self.call(payload)
      skope = Article.published
      articles = skope.order(published_at: :desc).includes(:user)
                      .paginate(page: payload[:page], per_page: payload[:per_page])
      Result[ok: true, val: { articles:, count: skope.count }]
    end
  end
end
