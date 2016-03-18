require 'test_helper'

class Main::ArticlePageTest < IT
  def setup
    super
    visit '/'
    within "#article_#{articles(:one).id}" do
      click_link 'Continued…'
    end
  end

  test "should go to article's page" do
    assert page.has_content? 'No comments.'
  end

  test "show add a comment" do
    try_add_invalid_article
    assert page.has_content? "can't be blank"
    assert page.has_content? "contains strong language."
    add_valid_article
    txt = "Your comment has been posted!"
    assert page.has_selector? "input[type=submit][value='#{txt}']"
    assert page.has_content? '1 comment'
    assert page.has_content? 'Nice article man!'
  end

  private

    def try_add_invalid_article
      fill_in 'comment_text', with: "Fuck this shit!"
      click_button "Post this comment"
    end

    def add_valid_article
      fill_in 'comment_author', with: "David"
      fill_in 'comment_text', with: "Nice article man!"
      click_button "Post this comment"
    end
end