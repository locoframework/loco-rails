# frozen_string_literal: true

require 'test_helper'

class Admin
  class ArticlesListTest < IT
    include CommonHelpers
    include AdminHelpers

    def setup
      super
      sign_in
      click_on 'Articles'
    end

    test 'should auto update an article' do
      assert page.has_content? 'A Guide to Testing Rails Applications'
      assert page.has_content? 'Rails fabric from the beginning'
      update_article articles(:one)
      assert page.has_content? 'AGtTRA'
      assert page.has_content? 'TESTING_SUPPORT...' * 6
    end

    test 'should auto load newly published articles' do
      assert_not page.has_content? 'What is Active Record?'
      publish_article articles(:two)
      assert page.has_content? 'What is Active Record?'
    end

    test 'should auto increment / decrement comments quantity' do
      assert page.has_content? '0 comments'
      comment = create_comment_for_article :one
      assert page.has_content? '1 comment'
      sleep 0.1
      destroy_comment comment
      assert page.has_content? '0 comments'
    end
  end
end
