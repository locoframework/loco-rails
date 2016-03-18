require 'test_helper'

class User::ArticlesCreatePageTest < IT
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
end