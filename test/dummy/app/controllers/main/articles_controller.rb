# frozen_string_literal: true

module Main
  class ArticlesController < MainController
    def index
      @articles = Query.new.articles.published(page: params[:page], per_page: 3)
      @count = @articles.total_entries
    end

    def show
      @article = Query.new.articles.find(params.expect(:id))
    end
  end
end
