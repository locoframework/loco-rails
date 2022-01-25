# frozen_string_literal: true

class Admin
  class ArticlesController < AdminController
    def published
      respond_to do |format|
        format.html { render }
        format.json do
          skope = Article.published
          @articles = skope.order('published_at DESC').includes(:user).paginate(
            page: params[:page],
            per_page: 4
          )
          @count = skope.count
        end
      end
    end

    def show
      @article = Article.includes(:user).find params[:id]
      @abbr = params[:abbr].present?
    end

    def edit
      render
    end

    def update
      article = Article.find params[:id]
      if article.update article_params
        render json: {
          success: true,
          status: 200,
          flash: { success: 'Article updated!' },
          data: {}
        }
      else
        render json: { success: false, status: 400, errors: article.errors }
      end
    end

    private

    def article_params
      params.require(:article).permit :admin_review, :category_id,
                                      :admin_rate, :admin_review_started_at,
                                      :published
    end
  end
end
