# frozen_string_literal: true

require 'test_helper'

class Admin
  class ReviewArticleTest < IT
    include AdminHelpers

    def setup
      super
      sign_in
      click_on 'Articles'
      click_on 'Review'
    end

    test 'should auto update an article' do
      update_article articles(:one)
      assert page.has_content? 'AGtTRA'
      assert page.has_content? 'TESTING_SUPPORT...' * 6
    end

    test 'should update an article' do
      submit_review
      visit "admin/articles/#{articles(:one).id}/edit"
      script = "document.getElementById('article_published').checked === true"
      assert_not page.evaluate_script(script)
      sleep 0.1
      assert_equal 'Damn good article', find(:css, 'textarea').value
      script = %{document.querySelector('input[name="article[admin_rate]"]:checked').value}
      assert_equal '5', page.evaluate_script(script)
      script = %{document.querySelector('select option:checked').textContent}
      assert_equal 'Health', page.evaluate_script(script)
      assert articles(:one).reload.admin_review_time.positive?
    end

    private

    def submit_review
      uncheck 'Published'
      fill_in 'Short review', with: 'Damn good article'
      choose 'Amazing'
      select 'Health', from: 'Category'
      click_button 'Update Article'
    end
  end
end
