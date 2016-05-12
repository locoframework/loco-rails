module AdminHelpers
  def sign_in
    visit '/admin/sessions/new'
    fill_in 'Email', with: 'zbigniew.humeniuk@motteq.com'
    fill_in 'Password', with: 'ubersecure!'
    click_button 'Sign In'
  end
end