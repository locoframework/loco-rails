# frozen_string_literal: true

class User
  class ArticlesController < UserController
    before_action :set_article, only: %i[new edit update destroy publish]

    CREATE_NOTICE = 'Article was successfully created.'
    DESTROY_NOTICE = 'Article was successfully destroyed.'
    DESTROY_ALERT = "Article can't be destroyed because is published."

    def index
      respond_to do |format|
        format.html { render }
        format.json do
          @articles = current_user.articles.order('created_at ASC')
                                  .paginate page: params[:page], per_page: 5
          @count = current_user.articles.count
        end
      end
    end

    def show
      respond_to do |format|
        format.html { render }
        format.json do
          set_article
          @abbr = params[:abbr].present? ? true : false
        end
      end
    end

    def new
      render
    end

    def edit
      @mark = Time.current.to_f.to_s
      emit @article, :updating, data: { mark: @mark },
                                to: [@article.published? ? :all : current_user]
    end

    def create
      @article = current_user.articles.new article_params
      success = @article.save
      emit(@article, :created, to: current_user) if success
      html_json_response success, @article,
                         notice_json: CREATE_NOTICE,
                         notice_html: CREATE_NOTICE,
                         redirect_to: @article
    end

    def update
      success = @article.update article_params
      emit(@article, :updated, to: [@article.published? ? :all : current_user]) if success
      html_json_response success, @article,
                         notice_json: 'Article updated!',
                         notice_html: 'Article was successfully updated.',
                         redirect_to: articles_url
    end

    def publish
      if @article.publish
        emit @article, :published, data: { id: @article.id }
        emit @article, :updated, to: current_user
        render json: { success: true, status: 200 }
      else
        render json: { success: false, status: 400, errors: @article.errors }
      end
    end

    def destroy
      success = @article.destroy
      emit(@article, :destroyed, to: current_user) if success
      respond_to do |format|
        format.html do
          flash[success ? :notice : :alert] = success ? DESTROY_NOTICE : DESTROY_ALERT
          redirect_to user_articles_url
        end
        format.json { json_response_for_destroy @article }
      end
    end

    private

    def set_article
      @article = if params[:id].present?
                   current_user.articles.find params[:id]
                 else
                   current_user.articles.new
                 end
    end

    def article_params
      params.require(:article).permit(:title, :text)
    end

    def json_response_for_destroy(article)
      if success
        success_response 200, DESTROY_NOTICE, id: article.id
      else
        failure_response 422, DESTROY_ALERT
      end
    end

    def html_json_response(success, article, data = {})
      if success
        respond_to do |format|
          format.json { success_response 200, data[:notice_json], {} }
          format.html { redirect_to data[:redirect_to], notice: data[:notice_html] }
        end
      else
        respond_to do |format|
          format.json { failure_response 400, article.errors }
          format.html { render :edit }
        end
      end
    end
  end
end
