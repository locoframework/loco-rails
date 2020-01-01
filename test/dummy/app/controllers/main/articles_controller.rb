# frozen_string_literal: true

module Main
  class ArticlesController < MainController
    def index
      skope = Article.published
      @articles = skope.order('published_at DESC')
                       .includes(:user)
                       .paginate page: params[:page], per_page: 3
      @count = skope.count
    end

    def show
      respond_to do |format|
        format.json do
          @article = Article.published.includes(:user).find params[:id]
          @abbr = params[:abbr].present? ? true : false
        end
        format.html { render }
      end
    end
  end
end
