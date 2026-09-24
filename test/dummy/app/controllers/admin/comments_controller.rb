# frozen_string_literal: true

module Admin
  class CommentsController < AdminController
    before_action :set_article, only: %i[show edit update]
    before_action :set_comment, only: %i[show edit update]

    def show
      render
    end

    def edit
      render
    end

    def update
      if @comment.update comment_params
        Loco.emit({ event: :updated, article_id: @article.id }, subject: @comment)
        render json: {
          ok: true,
          status: 200,
          flash: { success: 'Comment updated!' }, data: {}
        }
      else
        render json: { ok: false, status: 400, errors: @comment.errors }
      end
    end

    private

    def comment_params
      params.expect comment: %i[author text emotion pinned admin_rate]
    end

    def set_article
      @article = Article.find params[:article_id]
    end

    def set_comment
      @comment = @article.comments.find params[:id]
    end
  end
end
