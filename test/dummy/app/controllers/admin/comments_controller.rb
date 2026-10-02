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
                    payload: { article_id: params[:article_id], id: params[:id], comment: comment_params },
                    opts: { ars: { admin: current_admin } })
      if res.ok
        ok_resp(flash: 'Comment updated!')
      else
        err_resp(res.val[:comment].errors)
      end
    end

    private

    def comment_params
      params.expect comment: %i[author text emotion pinned admin_rate]
    end

    def find_comment
      res = Query.new(current_admin).comments.find(article_id: params.expect(:article_id), id: params.expect(:id))
      @article, @comment = res.values_at(:article, :comment)
    end
  end
end
