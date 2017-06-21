require 'test_helper'

class Admin::ReviewArticleTest < IT
  include Loco::Emitter
  include AdminHelpers

  def setup
    super
    sign_in
    click_on "Articles"
    click_on "Review"
  end

  test "should auto update an article" do
    update_article articles(:one)
    assert page.has_content? "AGtTRA"
    assert page.has_content? "TESTING_SUPPORT..." * 6
  end

  test "should update an article" do
    submit_review
    visit "admin/articles/#{articles(:one).id}/edit"
    assert_not page.evaluate_script("$('#article_published').is(':checked')")
    assert_equal 'Damn good article', find(:css, 'textarea').value
    assert_equal '5', page.evaluate_script(%{$('input[name="article[admin_rate]"]:checked').val()})
    assert_equal 'Health', page.evaluate_script(%{$('select option:selected').text()})    
    assert articles(:one).admin_review_time > 0
  end

  private

    def submit_review
      uncheck "Published"
      fill_in 'Short review', with: 'Damn good article'
      choose "Amazing"
      select 'Health', from: 'Category'
      click_button 'Update Article'
    end
end
