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
          Ephemeron.used(set_article)
          @abbr = params[:abbr].present? ? true : false
        end
      end
    end

    def new
      @article = current_user.articles.new
    end

    def edit
      @mark = Time.current.to_f.to_s
      emit Ephemeron.used(@article), :updating, data: { mark: @mark },
                                                for: [@article.published? ? :all : current_user]
    end

    def create
      @article = current_user.articles.new article_params
      success = @article.save
      emit(@article, :created, for: [current_user]) if success
      html_json_response success, @article,
                         notice_json: CREATE_NOTICE,
                         notice_html: CREATE_NOTICE,
                         redirect_to: @article
    end

    def update
      @article.assign_attributes article_params
      success = @article.valid?
      Ephemeron.after_save! do
        emit(@article, :updated, for: [@article.published? ? :all : current_user]) if success
      end
      html_json_response success, @article,
                         notice_json: 'Article updated!',
                         notice_html: 'Article was successfully updated.',
                         redirect_to: articles_url
    end

    def publish
      if @article.publish
        emit @article, :published, data: { id: @article.id }
        emit @article, :updated, for: [current_user]
        render json: { success: true, status: 200 }
      else
        render json: { success: false, status: 400, errors: @article.errors }
      end
    end

    def destroy
      success = @article.destroy
      emit(@article, :destroyed, for: [current_user]) if success
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
      @article = current_user.articles.find params[:id]
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
  end
end
