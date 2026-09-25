# frozen_string_literal: true

class Query
  def initialize(user: nil)
    @user = user
  end

  def articles = Article.new(articles_skope)

  def comments = Comment.new(articles_skope)

  private

  def articles_skope = @user ? @user.articles : ::Article
end
