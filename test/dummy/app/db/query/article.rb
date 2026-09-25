# frozen_string_literal: true

class Query
  class Article
    class << self
      def published(page:, per_page:)
        skope = ::Article.published
        articles = skope.order(published_at: :desc).includes(:user).paginate(page:, per_page:)
        { articles:, count: skope.count }
      end
    end

    def initialize(skope)
      @skope = skope
    end

    def find(id, published: false)
      skope = published ? @skope.published : @skope
      skope.includes(:user, :comments).find(id)
    end
  end
end
