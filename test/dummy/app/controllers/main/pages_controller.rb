# frozen_string_literal: true

module Main
  class PagesController < MainController
    def index
      @articles = perform(query: Article::Published, payload: { page: 1, per_page: 3 }).val[:articles]
    end
  end
end
