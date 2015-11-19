class Main::CommentsController < MainController
  def index
    skope = Comment.where(article_id: params[:article_id])
    @comments = skope.order("created_at ASC").paginate page: params[:page], per_page: 5
    @count = skope.count
  end

  def create
    comment = Comment.new comment_params
    if comment.save
      emit comment, :created, data: {article_id: comment.article_id}
      render json: {
        success: true,
        status: 201,
        flash: {success: 'Your comment has been posted!'}
      }
    else
      render json: {success: false, status: 400, errors: comment.errors}
    end
  end

  def show
    @comment = Comment.where(article_id: params[:article_id]).find params[:id]
  end

  private

    def comment_params
      params.require(:comment).permit :author, :text, :article_id
    end
end