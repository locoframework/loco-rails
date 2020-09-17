# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionManagerTest < TC
    before do
      @user = users(:user_zbig)
      @described_class = Loco::WsConnectionManager
      @subject = @described_class.new(@user)
    end

    describe '#identifier' do
      it do
        assert_equal "user:#{@user.id}", @subject.identifier
        assert_equal 'foo', @described_class.new('foo').identifier
      end
    end
  end
end
