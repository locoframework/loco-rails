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

  def update_article name
    articles(name).tap do |a|
      a.title = 'WiAR'
      a.text = 'Lorem Ipsum II'
      a.save!
    end
    emit articles(name), :updated, for: [users(:user_zbig)]
  end

  def destroy_article name
    articles(name)
    emit articles(name), :destroyed, for: [articles(name).user]
  end
end