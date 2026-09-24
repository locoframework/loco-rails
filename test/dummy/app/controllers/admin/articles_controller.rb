# frozen_string_literal: true

module Admin
  class ArticlesController < AdminController
    def published
      res = perform(query: Article::Published, payload: { page: params[:page], per_page: 4 })
      @articles, @count = res.val.values_at(:articles, :count)
    end

    def show
      @article = perform(query: Article::Find, payload: { id: params[:id] }).val[:article]
      @abbr = params[:abbr].present?
    end

    def edit
      @article = perform(query: Article::Find, payload: { id: params[:id] }).val[:article]
    end

    def update
      res = perform(action: Article::Review, payload: { id: params[:id], article: article_params })
      if res.ok
        success_response(200, flash: 'Article updated!', data: {})
      else
        failure_response(400, res.val[:article].errors)
      end
    end

    private

    def article_params
      params.expect article: %i[admin_review category_id
                                admin_rate admin_review_started_at
                                published]
    end
  end
end
