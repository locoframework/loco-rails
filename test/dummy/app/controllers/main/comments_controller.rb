# frozen_string_literal: true

module Main
  class CommentsController < MainController
    def show
      @comment = Comment.where(article_id: params[:article_id]).find(params[:id])
    end

    def create
      comment = Comment.new(comment_params)
      if comment.save
        Loco.emit({ article_id: comment.article_id, event: :created,
                    comments_count: comment.article.comments.count }, subject: comment)
        success_response(
          201,
          flash: 'Your comment has been posted!',
          data: comment.as_json(only: %i[id author text article_id created_at])
        )
      else
        failure_response(400, comment.errors)
      end
    end

    private

    def comment_params
      params.expect comment: %i[author text article_id]
    end
  end
end
