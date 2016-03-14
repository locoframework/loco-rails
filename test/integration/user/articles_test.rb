require 'test_helper'

class User::ArticlesTest < IT
  include Loco::Emitter
  include UserHelpers

  def setup
    super
    confirm_user :user_jane
    sign_in_user 'jane@example.com', 'secret'
  end

  test "should add article" do
    click_on 'New Article'
    try_add_invalid_article
    assert page.has_content? "can't be blank"
    assert page.has_content? "Article contains strong language."
    add_valid_article
    txt = "Article was successfully created."
    assert page.has_selector? "input[type=submit][value='#{txt}']"
  end

  test "should update list of user's articles" do
    create_article_for :user_jane
    assert page.has_content? 'Article #1'
    assert page.has_content? 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
  end

  test "should publish article" do
    article = create_article_for :user_jane
    within "#article_#{article.id}" do
      click_link 'Show'
    end
    click_link 'Publish'
    assert page.has_content? 'Published!'
  end

  test "should update published on articles list" do
    article = create_article_for :user_jane
    visit '/user/articles'
    article.publish
    emit article, :updated, for: [users(:user_jane)]
    within "#article_#{article.id} td.published" do
      assert page.has_content? "yes"
    end
  end

  private

    def try_add_invalid_article
      fill_in 'Text', with: 'maaan.. fuck it'
      click_button 'Create Article'
    end

    def add_valid_article
      fill_in 'Title', with: 'Article #1'
      fill_in 'Text', with: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
      click_button 'Create Article'
    end

    def create_article_for user_name
      article = users(user_name).articles.new({
        title: 'Article #1',
        text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
      }).tap{ |a| a.save! }
      emit article, :created, for: [users(user_name)]
      article
    end
end