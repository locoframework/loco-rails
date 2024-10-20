# frozen_string_literal: true

module Admin
  class CommentsController < AdminController
    before_action :set_article, only: %i[index show edit update]
    before_action :set_comment, only: %i[show edit update]

    def index
      skope = Comment.where article_id: @article.id
      @comments = skope.order('created_at ASC').paginate page: params[:page], per_page: 5
      @count = skope.count
    end

    def show
      render
    end

    def edit
      render
    end

    def update
      if @comment.update comment_params
        emit @comment, :updated, payload: { article_id: @article.id }
        render json: {
          success: true,
          status: 200,
          flash: { success: 'Comment updated!' }, data: {}
        }
      else
        render json: { success: false, status: 400, errors: @comment.errors }
      end
    end

    private

    def comment_params
      params.require(:comment).permit :author, :text, :emotion, :pinned, :admin_rate
    end

    def set_article
      @article = Article.find params[:article_id]
    end

    def set_comment
      @comment = @article.comments.find params[:id]
    end
  end
end
