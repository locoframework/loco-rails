# frozen_string_literal: true

require 'test_helper'

class SigningUpTest < IT
  test 'signing up user' do
    browse_to_sign_up_page
    fill_in_form
    assert page.has_content?('Please wait while administrator verifies your account')
    admin_went_to_user_edit_page
    assert page.has_content?('Your account is just verified...')
    admin_confirmed_user
    sleep 0.5
    assert page.has_content?('Your account has been verified. You can sign in now.')
  end

  test 'signing up user and go to articles page' do
    browse_to_sign_up_page
    fill_in_form
    assert page.has_content?('Please wait while administrator verifies your account')
    click_link 'main page'
    sleep 0.5
    Loco.emit({ type: 'USER_CONFIRMED' }, to: user.token)
    assert page.has_content?('Your account has been verified. You can sign in now.')
    assert_match %r{/user/sessions/new\?event=confirmed$}, current_url
  end

  private

  def browse_to_sign_up_page
    visit '/'
    click_on 'Sign up'
  end

  def fill_in_form
    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: 'secret'
    fill_in 'Password confirmation', with: 'secret'
    fill_in 'Username', with: 'joe'
    click_button 'Create User'
  end

  def admin_went_to_user_edit_page
    Loco.emit user, :confirming, for: user.token
  end

  def admin_confirmed_user
    Loco.emit user, :confirmed, for: user.token
  end

  def user
    User.find_by email: 'joe@example.com'
  end
end
