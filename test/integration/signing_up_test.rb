# frozen_string_literal: true

require 'test_helper'

class SigningUpTest < IT
  include Loco::Emitter

  test 'signing up user' do
    browse_to_sign_up_page
    fill_in_form
    assert page.has_content?('Please wait while administrator verifies your account')
    admin_went_to_user_edit_page
    assert page.has_content?('Your account is just verified...')
    admin_confirmed_user
    assert page.has_content?('Your account has been verified. You can sign in now.')
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
      emit user, :confirming, for: connection.token
    end

    def admin_confirmed_user
      emit user, :confirmed, for: connection.token
    end

    def user
      User.find_by email: 'joe@example.com'
    end

    def connection
      Connection.for_obj(user).last
    end
end
