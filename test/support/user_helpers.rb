# frozen_string_literal: true

module UserHelpers
  include Loco::Emitter

  def confirm_user(name)
    users(name).confirmed = true
    users(name).save!
  end

  def sign_in_user(email, pass)
    visit '/'
    click_on 'Sign in'
    fill_in 'Email', with: email
    fill_in 'Password', with: pass
    click_button 'Sign In'
  end

  def update_article(name)
    articles(name).tap do |a|
      a.title = 'WiAR'
      a.text = 'Lorem Ipsum II' * 8
      a.save!
    end
    emit articles(name), :updated, for: [users(:zbig)]
  end

  def destroy_article(name)
    article = articles name
    article.destroy
    emit article, :destroyed, for: [article.user]
  end

  def join_room(user, room)
    HubFinder.new(room).find.add_member user
    emit room, :member_joined, data: {
      room_id: room.id,
      member: {
        id: user.id,
        username: user.username
      }
    }
  end
end
