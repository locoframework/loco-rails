module UserHelpers
  def confirm_user name
    users(name).confirmed = true
    users(name).save!
  end

  def sign_in_user email, pass
    visit '/'
    click_on 'Sign in'
    fill_in 'Email', with: email
    fill_in 'Password', with: pass
    click_button 'Sign In'
  end
end