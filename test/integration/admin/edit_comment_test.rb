# frozen_string_literal: true

require 'test_helper'

class Admin
  class EditCommentTest < IT
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
      sleep 0.1
      assert_equal 'Ryan',
                   page.evaluate_script(%(window.test['commentFormObj']['author']))
      assert_equal 'Some nice thoughts dude',
                   page.evaluate_script(%(window.test['commentFormObj']['text']))
      assert_equal false,
                   page.evaluate_script(%(window.test['commentFormObj']['pinned']))
      assert_equal 3,
                   page.evaluate_script(%(window.test['commentFormObj']['adminRate']))
      assert_equal 0,
                   page.evaluate_script(%(window.test['commentFormObj']['emotion']))
      assert_equal articles(:one).id,
                   page.evaluate_script(%(window.test['commentFormObj']['articleId']))
    end
  end
end
