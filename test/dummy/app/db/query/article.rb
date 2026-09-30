# frozen_string_literal: true

class Query
  class Article
    def initialize(skope)
      @skope = skope
    end

    def all(page:, per_page:)
      @skope.order(:created_at).paginate(page:, per_page:)
    end

    def published(page:, per_page:)
      skope = @skope.published
      articles = skope.order(published_at: :desc).includes(:user).paginate(page:, per_page:)
      { articles:, count: skope.count }
    end

    def find(id)
      @skope.includes(:user, :comments).find(id)
    end
  end
end
