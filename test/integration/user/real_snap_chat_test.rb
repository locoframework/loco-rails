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
      click_on 'Join', match: :first
      sleep 0.1
    end

    def teardown
      super
      HubFinder.new(@room).find.destroy
    end

    test "should show room's members" do
      assert page.has_content? 'zbig'
      join_room users(:jane), @room
      assert page.has_content? 'jane'
    end

    test 'should send messages' do
      join_room users(:jane), @room
      fill_in 'message', with: 'Hello Jane!'
      find('#message').native.send_keys :return
      perform_enqueued_jobs
      assert page.has_content? 'zbig: Hello Jane!'
      payload = { type: 'NEW_MESSAGE', message: 'Hi zbig!', author: 'jane' }
      idempotency_key = Loco.emit payload, to: HubFinder.new(@room).find, ws_only: true
      Loco.emit payload.merge(idempotency_key:), to: HubFinder.new(@room).find, ws_only: true
      sleep 0.1
      assert_equal 2, page.all('p.msg').count
      assert page.has_content? 'jane: Hi zbig!'
    end

    test 'should show info about joining room after returning from disconnection' do
      go_disconnected
      sleep 0.1
      join_room users(:jane), @room
      go_connected
      assert page.has_content? 'jane'
    end

    test 'should create persistent message record when message_type is persistent' do
      join_room users(:jane), @room

      # Send persistent message
      choose 'message_type_persistent'
      fill_in 'message', with: 'This is a persistent message'
      find('#message').native.send_keys :return
      perform_enqueued_jobs

      # Verify message appears on page
      assert page.has_content? 'zbig: This is a persistent message'

      # Verify message record was created in database
      message = Message.last
      assert_equal 'This is a persistent message', message.content
      assert_equal @room.id, message.room_id
      assert_equal users(:zbig).id, message.user_id
      assert_equal 1, @room.messages.count
    end

    test 'should not create message record when message_type is ephemeral' do
      join_room users(:jane), @room

      # Send ephemeral message (default)
      choose 'message_type_ephemeral'
      fill_in 'message', with: 'This is an ephemeral message'
      find('#message').native.send_keys :return
      perform_enqueued_jobs

      # Verify message appears on page
      assert page.has_content? 'zbig: This is an ephemeral message'

      # Verify no message record was created in database
      assert_equal 0, @room.messages.count
    end

    test 'should display existing persistent messages when entering room' do
      # Create some persistent messages before entering room
      Message.create!(room: @room, user: users(:zbig), content: 'First persistent message')
      Message.create!(room: @room, user: users(:jane), content: 'Second persistent message')

      # Enter the room
      visit user_room_path(@room)

      # Verify messages are displayed
      assert page.has_content? 'zbig: First persistent message'
      assert page.has_content? 'jane: Second persistent message'
      assert_equal 2, page.all('p.msg').count
    end

    test 'should limit displayed messages to last 50' do
      # Create 55 persistent messages
      55.times do |i|
        Message.create!(room: @room, user: users(:zbig), content: "Message #{i + 1}.")
      end

      # Enter the room
      visit user_room_path(@room)

      # Verify only last 50 messages are displayed
      assert_equal 50, page.all('p.msg').count
      assert page.has_content? 'zbig: Message 6.'  # First message in the 50
      assert page.has_content? 'zbig: Message 55.' # Last message
      assert_not page.has_content? 'zbig: Message 1.' # Should not be displayed
      assert_not page.has_content? 'zbig: Message 5.' # Should not be displayed
    end
  end
end
