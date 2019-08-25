class User::CommentsController < UserController
  before_action :set_article, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  def index
    skope = Comment.where article_id: @article.id
    @comments = skope.order("created_at ASC").paginate page: params[:page], per_page: 10
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
      emit @comment, :updated, data: {article_id: @article.id}
      respond_to do |f|
        f.json{ render json: {ok: true, id: @comment.id} }
        f.html{ redirect_to edit_user_article_url(@article), notice: "Comment has been updated." }
      end
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy
    emit @comment, :destroyed, data: {article_id: @article.id}
    redirect_to edit_user_article_url(@article), notice: "Comment has been deleted."
  end

  private

    def comment_params
      permitted_params = [:author, :text]
      if current_admin
        permitted_params << :approved
      end
      params.require(:comment).permit *permitted_params
    end

    def set_article
      @article = current_user.articles.find params[:article_id]
    end

    def set_comment
      @comment = @article.comments.find params[:id]
    end
end
