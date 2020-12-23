# frozen_string_literal: true

require 'test_helper'

module Loco
  class NotificationTest < TC
    before do
      @user = users(:zbig)
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
