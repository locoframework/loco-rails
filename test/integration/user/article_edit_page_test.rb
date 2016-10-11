require 'test_helper'

class User::ArticleEditPageTest < IT
  include Loco::Emitter
  include CommonHelpers
  include UserHelpers

  def setup
    super
    sign_in_user 'zbigniew.humeniuk@example.com', 'secret'
    within("#article_#{articles(:two).id}"){ click_link 'Edit' }
  end

  test "should show info about editing" do
    sleep 0.1
    emit articles(:two), :updating, data: {mark: Time.current.to_f.to_s}, for: [users(:user_zbig)]
    assert page.has_content? 'Uuups someone else started editing this article.'
  end

  test "should update article" do
    fill_in 'Title', with: 'What is Active Record? (updated)'
    click_button 'Update Article'
    assert page.has_selector? "input[type=submit][value='Article updated!']"
  end

  test "should allow to update fields in order to have updated values" do
    sleep 0.1
    update_article :two
    within "div[data-attr='title']" do
      click_link 'apply changes'
      update_value_attr_for '#article_title'
      assert page.has_selector? "input[type=text][value='WiAR']"
    end
    within "div[data-attr='text']" do
      click_link 'apply changes'
      update_value_attr_for '#article_text'
      val = 'Lorem Ipsum II' * 8
      assert page.has_selector? "textarea[value='#{val}']"
    end
  end

  test "should auto load new comments" do
    within "#comments" do
      assert_not page.has_content? 'Some nice thoughts dude'
    end
    create_comment_for_article :two
    within "#comments" do
      assert page.has_content? 'Some nice thoughts dude'
    end
  end

  test "should auto update comment" do
    comment = create_comment_for_article :two
    visit "/user/articles/#{articles(:two).id}/edit"
    within "#comments" do
      assert_not page.has_content? 'Some nice thoughts dude (edited)'
    end
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
    sleep 0.1
    destroy_article :two
    assert page.has_content? 'Article has been deleted.'
  end
end