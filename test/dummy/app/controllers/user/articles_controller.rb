# frozen_string_literal: true

class User
  class ArticlesController < UserController
    CREATE_NOTICE = 'Article was successfully created.'
    DESTROY_NOTICE = 'Article was successfully destroyed.'
    DESTROY_ALERT = "Article can't be destroyed because is published."

    def index
      @articles = Query.new(current_user).articles.all(page: params[:page], per_page: 5)
    end

    def show
      @article = Query.new(current_user).articles.find(params.expect(:id))
    end

    def new
      @article = current_user.articles.new
    end

    def edit
      res = perform(action: Article::StartEditing, payload: { id: params[:id] }, opts: user_opts)
      @article, @mark = res.val.values_at(:article, :mark)
    end

    def create
      res = perform(action: Article::Create, payload: { article: article_params }, opts: user_opts)
      @article = res.val[:article]
      resp(res.ok, flash: CREATE_NOTICE, redirect_to: @article)
    end

    def update
      res = perform(action: Article::Update,
                    payload: { id: params[:id], article: article_params }, opts: user_opts)
      @article = res.val[:article]
      resp(res.ok, flash: 'Article updated!', redirect_to: articles_url)
    end

    def publish
      res = perform(action: Article::Publish, payload: { id: params[:id] }, opts: user_opts)
      if res.ok
        render json: { ok: true, status: 200 }
      else
        err_resp(400, res.val[:article].errors)
      end
    end

    def destroy
      res = perform(action: Article::Destroy, payload: { id: params[:id] }, opts: user_opts)
      respond_to do |f|
        f.html { redirect_to user_articles_url, res.ok ? { notice: DESTROY_NOTICE } : { alert: DESTROY_ALERT } }
        f.json do
          if res.ok
            ok_resp(200, flash: DESTROY_NOTICE, data: { id: res.val[:article].id })
          else
            err_resp(422, DESTROY_ALERT)
          end
        end
      end
    end

    private

    def article_params
      params.expect(article: %i[title text])
    end

    def resp(success, flash:, redirect_to:)
      if success
        respond_to do |f|
          f.json { ok_resp(200, flash:, data: {}) }
          f.html { redirect_to(redirect_to, notice: flash) }
        end
      else
        respond_to do |f|
          f.json { err_resp(400, @article.errors) }
          f.html { render :edit }
        end
      end
    end
  end
end
