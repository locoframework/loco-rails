# frozen_string_literal: true

class Query
  def initialize(actor = nil)
    @actor = actor
  end

  def articles = Article.new(articles_scope)

  def comments = Comment.new(articles_scope)

  def rooms = Room.new(::Room)

  def users = User.new(::User)

  private

  def articles_scope
    case @actor
    when ::User then @actor.articles
    when Admin::SupportMember then ::Article
    else ::Article.published
    end
  end
end
