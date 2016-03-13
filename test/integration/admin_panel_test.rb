require 'test_helper'

class AdminPanelTest < IT
  def setup
    super
    sign_in
  end

  test "signing in" do
    assert page.has_content?('Successfully signed in.')
  end

  test "confirming user" do
    within("#user_#{users(:user_jane).id}") do
      click_on "Edit"
    end
    check "Confirmed"
    click_on "Update User"
    assert page.has_selector?("input[type=submit][value='User updated!']")
    click_on 'Back'
    assert_equal 'Yes', find("#user_#{users(:user_jane).id}").find('td.confirmed').text
  end

  private

    def sign_in
      visit '/admin/sessions/new'
      fill_in 'Email', with: 'zbigniew.humeniuk@motteq.com'
      fill_in 'Password', with: 'ubersecure!'
      click_button 'Sign In'
    end
end