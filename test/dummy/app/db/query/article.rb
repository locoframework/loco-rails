# frozen_string_literal: true

class Query
  class Article
    def initialize(scope)
      @scope = scope
    end

    def all(page:, per_page:)
      @scope.order(:created_at).paginate(page:, per_page:)
    end

    def published(page:, per_page:)
      @scope.published.order(published_at: :desc).includes(:user).paginate(page:, per_page:)
    end

    def find(id)
      @scope.includes(:user, :comments).find(id)
    end
  end
end
