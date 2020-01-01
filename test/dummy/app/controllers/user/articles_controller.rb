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
                                for: [@article.published? ? :all : current_user]
    end

    def create
      @article = current_user.articles.new article_params
      if @article.save
        emit @article, :created, for: [current_user]
        respond_to do |format|
          format.json { success_response 201, CREATE_NOTICE, id: @article.id }
          format.html { redirect_to @article, notice: CREATE_NOTICE }
        end
      else
        respond_to do |format|
          format.json { failure_response 400, @article.errors }
          format.html { render :new }
        end
      end
    end

    def update
      if @article.update article_params
        emit @article, :updated, for: [@article.published? ? :all : current_user]
        respond_to do |format|
          format.json { success_response 200, 'Article updated!', {} }
          format.html { redirect_to articles_url, notice: 'Article was successfully updated.' }
        end
      else
        respond_to do |format|
          format.json { failure_response 400, @article.errors }
          format.html { render :edit }
        end
      end
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
      if (success = @article.destroy)
        emit @article, :destroyed, for: [current_user]
      end
      respond_to do |format|
        format.html do
          if success
            flash[:notice] = DESTROY_NOTICE
          else
            flash[:alert] = DESTROY_ALERT
          end
          redirect_to user_articles_url
        end
        format.json do
          if success
            render json: { success: true, status: 200, notice: DESTROY_NOTICE, id: @article.id }
          else
            render json: { success: false, status: 422, alert: DESTROY_ALERT }
          end
        end
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
  end
end
