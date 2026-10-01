# frozen_string_literal: true

module Admin
  class ArticlesController < AdminController
    def published
      @articles = scope.published(page: params[:page], per_page: 4)
      @count = @articles.total_entries
    end

    def show
      @article = scope.find(params.expect(:id))
      @abbr = params[:abbr].present?
    end

    def edit
      @article = scope.find(params.expect(:id))
    end

    def update
      res = perform(action: Article::Review, payload: { id: params[:id], article: article_params })
      if res.ok
        ok_resp(200, flash: 'Article updated!', data: {})
      else
        err_resp(400, res.val[:article].errors)
      end
    end

    private

    def scope = Query.new(current_admin).articles

    def article_params
      params.expect(article: %i[admin_review category_id
                                admin_rate admin_review_started_at
                                published])
    end
  end
end
