require 'test_helper'

class Admin::EditCommentTest < IT
  include Loco::Emitter
  include CommonHelpers
  include AdminHelpers

  def setup
    super
    create_comment_for_article :one
    sign_in
    click_on 'Articles'
    click_on 'Review'
    within '#comments' do
      click_on 'edit'
    end
  end

  test "should init js Comment's object based on form" do
    assert_equal 'Ryan', page.evaluate_script(%{App.Env.test['commentFormObj']['author']})
    assert_equal 'Some nice thoughts dude', page.evaluate_script(%{App.Env.test['commentFormObj']['text']})
    assert_equal false, page.evaluate_script(%{App.Env.test['commentFormObj']['pinned']})
    assert_equal 3, page.evaluate_script(%{App.Env.test['commentFormObj']['adminRate']})
    assert_equal 0, page.evaluate_script(%{App.Env.test['commentFormObj']['emotion']})
    assert_equal articles(:one).id, page.evaluate_script(%{App.Env.test['commentFormObj']['articleId']})
  end
end