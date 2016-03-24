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

  test "should auto update article" do
    update_article :two
    within "#article_title" do
      assert page.has_content? 'WiAR'
    end
    within "#article_text" do
      assert page.has_content? 'Lorem Ipsum II'
    end
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
    comment = create_comment_for_article :two
    within "#comments" do
      assert page.has_content? 'Some nice thoughts dude'
    end
    destroy_comment comment
    sleep 1
    within "#comments" do
      assert_not page.has_content? 'Some nice thoughts dude'
    end
  end

  test "should auto redirect to list of articles if article has been deleted" do
    destroy_article :two
    assert page.has_content? 'Article has been deleted.'
  end
end