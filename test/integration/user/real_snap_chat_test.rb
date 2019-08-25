# frozen_string_literal: true

require 'test_helper'

class User::RealSnapChatTest < IT
  include Loco::Emitter
  include UserHelpers
  include CapybaraOffline

  def setup
    super
    @room = Room.create! name: 'Business'
    sign_in_user 'zbigniew.humeniuk@example.com', 'secret'
    click_on 'RealSnapChat rooms'
    click_on 'Join'
    sleep 0.1
  end

  def teardown
    super
    HubFinder.new(@room).find.destroy
  end

  test "should show room's members" do
    join_room users(:user_jane), @room
    assert page.has_content? 'zbig'
    assert page.has_content? 'jane'
  end

  test 'should send messages' do
    perform_enqueued_jobs
    join_room users(:user_jane), @room
    fill_in 'message', with: 'Hello Jane!'
    find('#message').native.send_keys :return
    perform_enqueued_jobs
    assert page.has_content? 'zbig: Hello Jane!'
    emit_to HubFinder.new(@room).find, signal: 'message', message: 'Hi zbig!', author: 'jane'
    assert page.has_content? 'jane: Hi zbig!'
  end

  test 'should show info about joining room after returning from disconnection' do
    go_disconnected
    sleep 0.1
    join_room users(:user_jane), @room
    go_connected
    assert page.has_content? 'jane'
  end
end
