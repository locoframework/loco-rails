require 'test_helper'

class User::ArticleShowPageTest < IT
  include Loco::Emitter
  include CommonHelpers
  include UserHelpers

  def setup
    super
    delete_cookies
    sign_in_user 'zbigniew.humeniuk@example.com', 'secret'
    within("#article_#{articles(:two).id}"){ click_link 'Show' }
  end

  test "should publish article" do
    click_link 'Publish'
    assert page.has_content? 'Published!'
  end

  test "should auto load new comments" do
    create_comment_for_article :two
    within "#comments" do
      assert page.has_content? 'Some nice thoughts dude'
    end
  end

  test "should auto update comment" do
    comment = create_comment_for_article :two
    update_comment comment
    within "#comments" do
      assert page.has_content? 'Some nice thoughts dude (edited)'
    end
  end

  test "should auto remove comment if was destroyed" do
    skip "implement!"
  end
end