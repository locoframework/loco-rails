# frozen_string_literal: true

module Main
  class PagesController < MainController
    def index
      @articles = Query.new.articles.published(page: 1, per_page: 3)[:articles]
    end
  end
end
