# frozen_string_literal: true

require 'test_helper'

module Loco
  class NotificationTest < TC
    before do
      @user = users(:zbig)
    end

    describe '#message' do
      it 'carries its own position on the notification clock' do
        notification = Notification.create!(obj: [Article, 7], event: :updated, idempotency_key: 'abc', data: {})
        sync_time = (notification.created_at - Notification::Fetcher::OVERLAP).iso8601(6)
        expected = {
          loco: { idempotency_key: 'abc', sync_time: },
          type: 'updated',
          payload: {},
          obj_class: 'Article',
          obj_id: 7
        }
        assert_equal expected, notification.message
      end

      # key, type and payload all lived in `data` before the idempotency_key column
      it 'reads a row stored before the idempotency_key column' do
        wire = ->(n) { [n.message[:loco][:idempotency_key], n.message[:type], n.message[:payload]] }

        v6 = Notification.new(event: 'created', data: { 'foo' => 1, 'loco' => { 'idempotency_key' => 'a' } })
        assert_equal ['a', 'created', { 'foo' => 1 }], wire.(v6)

        pre7 = Notification.new(data: { 'payload' => { 'foo' => 1 }, 'type' => 'PING',
                                        'loco' => { 'idempotency_key' => 'b' } })
        assert_equal ['b', 'PING', { 'foo' => 1 }], wire.(pre7)
      end
    end

    describe '#recipient' do
      it do
        assert_equal 'foobar', Notification.new(recipient: 'foobar').recipient
        recipient = Notification.new(recipient: @user).recipient(shallow: true)
        assert_equal User.new(id: @user.id), recipient
        assert_equal @user, Notification.new(recipient: @user).recipient
        assert_equal User, Notification.new(recipient: User).recipient
      end
    end

    describe '#recipient=' do
      # described by #recipient
    end
  end
end
