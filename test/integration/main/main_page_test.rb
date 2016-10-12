require 'test_helper'

class Main::MainPageTest < IT
  include Loco::Emitter
  include CommonHelpers

  def setup
    super
    visit '/'
  end

  test "should async load articles" do
    assert page.has_content? 'A Guide to Testing Rails Applications'
  end

  test "should auto load published article" do
    sleep 0.5
    publish_article :two
    assert page.has_content? 'What is Active Record?'
  end

  test "should update title of recently updated article" do
    sleep 0.5
    articles(:one).tap do |a|
      a.title = 'AGtTRA'
      a.save!
    end
    emit articles(:one), :updated, for: [:all]
    assert page.has_content? 'AGtTRA'
  end

  test "should update number of comments if one was added" do
    sleep 0.5
    create_comment_for_article :one
    within "article#article_#{articles(:one).id}" do
      assert page.has_content? '1 comment'
    end
  end

  test "should update number of comments if one was deleted" do
    c1 = create_comment_for_article :one
    c2 = create_comment_for_article :one, author: 'Jason', text: 'Very interesting...'
    visit '/'
    within "article#article_#{articles(:one).id}" do
      assert page.has_content? '2 comments'
    end
    destroy_comment c1
    destroy_comment c2
    within "article#article_#{articles(:one).id}" do
      assert page.has_content? '0 comments'
    end
  end

  test "should load another page of articles on click" do
    create_articles
    visit '/'
    click_link 'Load more…'
    assert page.has_content? 'Configuring Rails Components'
  end

  private

    def publish_article name
      articles(name).publish
      emit articles(name), :published, data: {id: articles(name).id}
    end

    def destroy_comment comment
      comment.destroy
      emit comment, :destroyed, data: {article_id: comment.article_id}
    end

    def create_articles
      users(:user_zbig).articles.create!({
        title: 'Why Associations?',
        text: "Why do we need associations between models? Because they make common operations simpler and easier in your code. For example, consider a simple Rails application that includes a model for customers and a model for orders.",
        published_at: 2.days.ago
      })
      users(:user_jane).articles.create!({
        title: 'Form Helpers',
        text: "Forms in web applications are an essential interface for user input. However, form markup can quickly become tedious to write and maintain because of the need to handle form control naming and its numerous attributes.",
        published_at: 3.days.ago
      })
      users(:user_jane).articles.create!({
        title: 'Active Support Core Extensions',
        text: "Active Support is the Ruby on Rails component responsible for providing Ruby language extensions, utilities, and other transversal stuff.",
        published_at: 4.days.ago
      })
      users(:user_zbig).articles.create!({
        title: 'Configuring Rails Components',
        text: "In general, the work of configuring Rails means configuring the components of Rails, as well as configuring Rails itself. The configuration file config/application.rb and environment-specific configuration files (such as config/environments/production.rb) allow you to specify the various settings that you want to pass down to all of the components.",
        published_at: 5.days.ago
      })

    end
end