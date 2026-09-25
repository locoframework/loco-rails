# frozen_string_literal: true

module Main
  class CommentsController < MainController
    def show
      res = Query.new.comments.find(article_id: params[:article_id], id: params[:id])
      @comment = res[:comment]
    end

    def create
      res = perform(action: Comment::Create, payload: { comment: comment_params })
      comment = res.val[:comment]
      if res.ok
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
