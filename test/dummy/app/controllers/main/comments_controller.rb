# frozen_string_literal: true

module Main
  class CommentsController < MainController
    def count
      render json: { total: skope.count }
    end

    def index
      @comments = skope.paginate(
        page: params['page-num'],
        per_page: 5
      )
    end

    def create
      comment = Comment.new comment_params
      if comment.save
        Loco.emit(comment, :created, payload: { article_id: comment.article_id })
        success_response(201, 'Your comment has been posted!')
      else
        failure_response(400, comment.errors)
      end
    end

    def show
      @comment = Comment.where(article_id: params[:article_id]).find params[:id]
    end

    private

    def comment_params
      params.require(:comment).permit :author, :text, :article_id
    end

    def skope
      Comment.where(article_id: params[:article_id])
             .order('created_at ASC')
    end
  end
end
