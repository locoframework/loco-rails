# frozen_string_literal: true

class Query
  class User
    def initialize(scope)
      @scope = scope
    end

    def all(page:)
      @scope.order(created_at: :desc).paginate(page:, per_page: 10)
    end
  end
end
