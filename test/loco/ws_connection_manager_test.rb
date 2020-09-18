# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionManagerTest < TC
    before do
      @user = users(:user_zbig)
      @described_class = Loco::WsConnectionManager
      @subject = @described_class.new(@user)
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

    describe '#connected_uuids' do
      it 'returns connected UUIDs for a given resource' do
        WsConnectionStorage.instance.del(@subject.identifier)
        uuid = SecureRandom.uuid
        @subject.add(uuid)
        assert_equal [uuid], @subject.connected_uuids
      end
    end

    describe '#identifier' do
      it 'returns a correct format of an identifier' do
        assert_equal "user:#{@user.id}", @subject.identifier
        assert_equal 'foo', @described_class.new('foo').identifier
      end
    end
  end
end
