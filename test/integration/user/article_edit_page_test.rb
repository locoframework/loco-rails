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
    sleep 0.5
    emit articles(:two), :updating, data: {mark: Time.current.to_f.to_s}, for: [users(:user_zbig)]
    assert page.has_content? 'Uuups someone else started editing this article.'
  end

  test "should update article" do
    fill_in 'Title', with: 'What is Active Record? (updated)'
    click_button 'Update Article'
    assert page.has_selector? "input[type=submit][value='Article updated!']"
  end

  test "should allow to update the data of currently updated article on edit page" do
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
end