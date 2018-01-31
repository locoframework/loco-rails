class Main::CommentsController < MainController
  def count
    render json: {total: skope.count}
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

    def skope
      Comment.where(article_id: params[:article_id])
             .order('created_at ASC')
    end
end