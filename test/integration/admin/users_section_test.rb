require 'test_helper'

class Admin::UsersSectionTest < IT
  include Loco::Emitter
  include AdminHelpers

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

  test "should auto load recently added user" do
    user = User.create! email: 'david@example.com', username: 'david',
      password: 'secret', password_confirmation: 'secret'
    emit user, :created, for: Admin
    assert page.has_content? 'david@example.com'
  end
end