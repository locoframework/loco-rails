# frozen_string_literal: true

module Main
  class ArticlesController < MainController
    def index
      res = perform(query: Article::Published, payload: { page: params[:page], per_page: 3 })
      @articles, @count = res.val.values_at(:articles, :count)
    end

    def show
      @article = perform(query: Article::Find, payload: { id: params[:id], published: true }).val[:article]
    end
  end
end
