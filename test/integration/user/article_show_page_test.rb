require 'test_helper'

class User::ArticleShowPageTest < IT
  include UserHelpers

  def setup
    super
    sign_in_user 'zbigniew.humeniuk@example.com', 'secret'
    within("#article_#{articles(:two).id}"){ click_link 'Show' }
  end

  test "should publish article" do
    click_link 'Publish'
    assert page.has_content? 'Published!'
  end
end