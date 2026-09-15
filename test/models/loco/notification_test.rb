# frozen_string_literal: true

require 'test_helper'

module Loco
  class NotificationTest < TC
    before do
      @user = users(:zbig)
    end

    describe '#compact' do
      it 'carries its own position on the notification clock' do
        notification = Notification.create!(obj: [Article, 7], event: :updated,
                                            data: { 'loco' => { 'idempotency_key' => 'abc' } })
        obj_class, obj_id, event, data, sync_time = notification.compact

        assert_equal ['Article', 7, 'updated'], [obj_class, obj_id, event]
        assert_equal notification.created_at.iso8601(6), sync_time
        # The stored payload rides through untouched — sync_time is derived,
        # not part of what the caller emitted.
        assert_equal notification.data, data
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
