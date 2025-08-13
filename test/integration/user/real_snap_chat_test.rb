# frozen_string_literal: true

require 'test_helper'

class User
  class RealSnapChatTest < IT
    include UserHelpers
    include CapybaraOffline

    def setup
      super
      @room = Room.create! name: 'Business'
      sign_in_user 'zbigniew.humeniuk@example.com', 'secret'
      click_on 'RealSnapChat rooms'
      assert_selector "body[data-action='index']"
      perform_enqueued_jobs do
        click_on 'Join', match: :first
        assert_selector "body[data-action='show']"
      end
    end

    def teardown
      super
      FindHub.(room_id: @room.id).destroy
    end

    test "should show room's members" do
      assert_text 'zbig'
      join_room users(:jane), @room
      assert_text 'jane'
    end

    test 'should send messages' do
      join_room users(:jane), @room
      fill_in 'message', with: 'Hello Jane!'
      perform_enqueued_jobs do
        find('#message').native.send_keys :return
      end
      assert page.has_content? 'zbig: Hello Jane!'
      payload = { type: 'NEW_MESSAGE', message: 'Hi zbig!', author: 'jane' }
      idempotency_key = Loco.emit payload, to: FindHub.(room_id: @room.id), ws_only: true
      Loco.emit payload.merge(idempotency_key:), to: FindHub.(room_id: @room.id), ws_only: true
      sleep 0.1
      assert_equal 2, page.all('p.msg').count
      assert page.has_content? 'jane: Hi zbig!'
    end

    test 'should show info about joining room after returning from disconnection' do
      go_disconnected
      sleep 0.1
      join_room users(:jane), @room
      go_connected
      assert_text 'jane', wait: 5
    end

    test 'should create persistent message record when message_type is persistent' do
      join_room users(:jane), @room

      choose 'message_type_persistent'
      fill_in 'message', with: 'This is a persistent message'
      perform_enqueued_jobs do
        find('#message').native.send_keys :return
      end

      assert page.has_content? 'zbig: This is a persistent message'

      choose 'message_type_ephemeral'
      fill_in 'message', with: 'This is an ephemeral message'
      perform_enqueued_jobs do
        find('#message').native.send_keys :return
      end

      assert page.has_content? 'zbig: This is an ephemeral message'

      visit user_room_path(@room)
      assert page.has_content? 'zbig: This is a persistent message'
      assert_not page.has_content? 'zbig: This is an ephemeral message'

      Loco::Hub.get("room_#{@room.id}").members.each do |member|
        lt = Loco::Notification.find_by(obj_class: nil, obj_id: nil, event: nil, recipient_class: 'User',
                                        recipient_id: member.id)
        assert_equal 'NEW_MESSAGE', lt.data['type']
        assert_equal 'This is a persistent message', lt.data['message']
        assert_equal 'zbig', lt.data['author']
      end
    end

    test 'autoleaving room' do
      click_on 'RealSnapChat rooms'
      assert_selector "body[data-action='index']", wait: 5
      assert_equal '1', find("tr#room_#{@room.id} td.members").text
      sleep 5 # TODO: invalidate redis key faster in test env
      MaintainRoomMembers.clear(@room.id)
      perform_enqueued_jobs
      assert_equal '0', find("tr#room_#{@room.id} td.members").text
      assert find("tr#room_#{@room.id}").has_link?('Join', href: "/user/rooms/#{@room.id}/join")
    end
  end
end
