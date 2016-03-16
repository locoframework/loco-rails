require 'test_helper'

class User::ArticlesTest < IT
  include Loco::Emitter
  include CommonHelpers
  include UserHelpers

  def setup
    super
    sign_in_user 'zbigniew.humeniuk@example.com', 'secret'
  end

  test "should create article" do
    click_on 'New Article'
    try_add_invalid_article
    assert page.has_content? "can't be blank"
    assert page.has_content? "Article contains strong language."
    add_valid_article
    txt = "Article was successfully created."
    assert page.has_selector? "input[type=submit][value='#{txt}']"
  end

  test "should update list of user's articles" do
    create_article_for :user_zbig
    assert page.has_content? 'Article #1'
    assert page.has_content? 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'
  end

  test "should publish article" do
    within "#article_#{articles(:two).id}" do
      click_link 'Show'
    end
    click_link 'Publish'
    assert page.has_content? 'Published!'
  end

  test "should update published on articles list" do
    visit '/user/articles'
    articles(:two).publish
    emit articles(:two), :updated, for: [users(:user_zbig)]
    within "#article_#{articles(:two).id} td.published" do
      assert page.has_content? "yes"
    end
  end

  test "should show info about editing" do
    within("#article_#{articles(:two).id}"){ click_link 'Edit' }
    sleep 0.5
    emit articles(:two), :updating, for: [users(:user_zbig)], data: {mark: Time.current.to_f.to_s}
    assert page.has_content? 'Uuups someone else started editing this article.'
  end

  test "should update article" do
    within("#article_#{articles(:two).id}"){ click_link 'Edit' }
    fill_in 'Title', with: 'What is Active Record? (updated)'
    click_button 'Update Article'
    assert page.has_selector? "input[type=submit][value='Article updated!']"
  end

  test "should update title of updated article on articles list" do
    visit '/user/articles'
    update_article :two
    assert page.has_content? 'WiAR'
  end

  test "should allow to update the data of currently updated article on edit page" do
    within("#article_#{articles(:two).id}"){ click_link 'Edit' }
    sleep 0.5
    update_article :two
    within "div[data-attr='title']" do
      click_link 'apply changes'
      update_value_attr_for '#article_title'
      assert page.has_selector? "input[type=text][value='WiAR']"
    end
    within "div[data-attr='text']" do
      click_link 'apply changes'
      update_value_attr_for '#article_text'
      assert page.has_selector? "textarea[value='Lorem Ipsum II']"
    end
  end

  test "should remove article from list on destroy" do
    skip "TODO: implement"
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

    def update_article name
      articles(name).tap do |a|
        a.title = 'WiAR'
        a.text = 'Lorem Ipsum II'
        a.save!
      end
      emit articles(name), :updated, for: [users(:user_zbig)]
    end
end