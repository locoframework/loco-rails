# frozen_string_literal: true

module Main
  class PagesController < MainController
    def index
      @articles = Article.published.order(published_at: :desc)
                         .includes(:user).paginate(page: 1, per_page: 3)
    end
  end
end
