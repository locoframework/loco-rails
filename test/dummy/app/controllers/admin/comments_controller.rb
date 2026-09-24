# frozen_string_literal: true

module Admin
  class CommentsController < AdminController
    def show
      find_comment
    end

    def edit
      find_comment
    end

    def update
      res = perform(action: Comment::Update,
                    payload: { article_id: params[:article_id], id: params[:id], comment: comment_params })
      if res.ok
        success_response(200, flash: 'Comment updated!', data: {})
      else
        failure_response(400, res.val[:comment].errors)
      end
    end

    private

    def comment_params
      params.expect comment: %i[author text emotion pinned admin_rate]
    end

    def find_comment
      res = perform(query: Comment::Find, payload: { article_id: params[:article_id], id: params[:id] })
      @article, @comment = res.val.values_at(:article, :comment)
    end
  end
end
