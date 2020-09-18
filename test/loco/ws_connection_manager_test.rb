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
      it 'returns a correct format of identifier' do
        assert_equal "user:#{@user.id}", @subject.identifier
        assert_equal 'foo', @described_class.new('foo').identifier
      end
    end

    describe '#add' do
      it 'returns a correct structure' do
        uuid = SecureRandom.uuid
        travel_to Time.utc(2020) do
          @subject.add(uuid)
        end
        assert @subject.connected?(uuid)
      end
    end
  end
end
