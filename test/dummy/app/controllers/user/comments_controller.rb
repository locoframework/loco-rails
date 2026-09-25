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
      return render_update_failure unless res.ok

      respond_to do |f|
        f.json { render json: { ok: true, id: @comment.id } }
        f.html do
          redirect_to edit_user_article_url(@article),
                      notice: t('flash.comment_updated')
        end
      end
    end

    def destroy
      res = perform_on_comment(Comment::Destroy)
      redirect_to edit_user_article_url(res.val[:article]), notice: t('flash.comment_deleted')
    end

    private

    def render_update_failure
      respond_to do |f|
        f.json { render json: { ok: false, errors: @comment.errors }, status: :unprocessable_content }
        f.html { render :edit, status: :unprocessable_content }
      end
    end

    def comment_params
      permitted_params = %i[author text]
      permitted_params << :approved if current_admin
      params.expect(comment: [*permitted_params])
    end

    def perform_on_comment(action, **payload)
      perform(action:, payload: { article_id: params[:article_id], id: params[:id], **payload }, opts: user_opts)
    end

    def find_comment
      res = Query.new(current_user).comments.find(article_id: params[:article_id], id: params[:id])
      @article, @comment = res.values_at(:article, :comment)
    end
  end
end
