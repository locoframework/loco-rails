# frozen_string_literal: true

module Main
  class ArticlesController < MainController
    def index
      skope = Article.published
      @articles = skope.order(published_at: :desc)
                       .includes(:user)
                       .paginate page: params[:page], per_page: 3
      @count = skope.count
    end

    def show
      @article = Article.published.includes(:user, :comments).find params[:id]
    end
  end
end
