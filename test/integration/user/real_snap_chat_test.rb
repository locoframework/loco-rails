require 'test_helper'

class User::RealSnapChatTest < IT
  include Loco::Emitter
  include UserHelpers

  def setup
    super
    @room = Room.create! name: "Business"
    sign_in_user 'zbigniew.humeniuk@example.com', 'secret'
    click_on "RealSnapChat rooms"
    click_on "Join"
    sleep 0.1
  end

  def teardown
    super
    HubFinder.new(@room).find.destroy
  end

  test "should show room's members" do
    join_room users(:user_jane)
    assert page.has_content? 'zbig'
    assert page.has_content? 'jane'
  end

  test "should send messages" do
    join_room users(:user_jane)
    fill_in 'message', with: 'Hello Jane!'
    find('#message').native.send_keys :return
    assert page.has_content? 'zbig: Hello Jane!'
    emit_to HubFinder.new(@room).find, signal: 'message', message: 'Hi zbig!', author: 'jane'
    assert page.has_content? 'jane: Hi zbig!'
  end

  private

    def join_room user, room = @room
      HubFinder.new(room).find.add_member user
      emit room, :member_joined, data: {
      room_id: room.id,
        member: {
          id: user.id,
          username: user.username,
        }
      }
    end
end