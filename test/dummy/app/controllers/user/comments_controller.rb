# frozen_string_literal: true

class User
  class CommentsController < UserController
    def show
      find_comment
    end

    def edit
      find_comment
    end

    def update
      res = perform_on_comment(Comment::Update, comment: comment_params)
      @article, @comment = res.val.values_at(:article, :comment)
      respond_to do |f|
        if res.ok
          f.json { ok_resp }
          f.html { redirect_to [:edit, :user, @article], notice: t('flash.comment_updated') }
        else
          f.json { err_resp(@comment.errors) }
          f.html { render :edit, status: :unprocessable_content }
        end
      end
    end

    def destroy
      res = perform_on_comment(Comment::Destroy)
      redirect_to edit_user_article_url(res.val[:article]), notice: t('flash.comment_deleted')
    end

    private

    def comment_params
      permitted_params = %i[author text]
      permitted_params << :approved if current_admin
      params.expect(comment: [*permitted_params])
    end

    def perform_on_comment(action, **payload)
      perform(action:, payload: { article_id: params[:article_id], id: params[:id], **payload }, opts: user_opts)
    end

    def find_comment
      res = Query.new(current_user).comments.find(article_id: params.expect(:article_id), id: params.expect(:id))
      @article, @comment = res.values_at(:article, :comment)
    end
  end
end
