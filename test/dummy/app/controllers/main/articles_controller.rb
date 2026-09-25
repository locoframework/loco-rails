# frozen_string_literal: true

module Main
  class ArticlesController < MainController
    def index
      res = Query::Article.published(page: params[:page], per_page: 3)
      @articles, @count = res.values_at(:articles, :count)
    end

    def show
      @article = Query.new.articles.find(params[:id])
    end
  end
end
