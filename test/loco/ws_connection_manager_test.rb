# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionManagerTest < TCWithMocks
    before do
      @user = users(:user_zbig)
      @described_class = Loco::WsConnectionManager
      @subject = @described_class.new(@user)
    end

    describe '#add' do
      it 'adds UUID and it is considered connected' do
        uuid = SecureRandom.uuid
        travel_to Time.utc(2020) do
          @subject.add(uuid)
        end
        assert @subject.connected?(uuid)
      end

      it 'checks connections' do
        reset
        uuid = SecureRandom.uuid
        time = Time.utc(2020, 0o1, 0o1, 11, 30)
        travel_to(time) { @subject.add(uuid) }
        travel_to(time + (3 * 60 - 1).seconds) { @subject.add(SecureRandom.uuid) }
        assert_equal '2020-01-01T11:30:00.000000Z', @subject.send(:data)[uuid]
        expect(SenderJob).to receive(:perform_later).with(uuid, loco: { connection_check: true })
        travel_to(time + (3 * 60 + 1).seconds) { @subject.add(SecureRandom.uuid) }
        assert_equal({ 'check' => '2020-01-01T11:33:01.000000Z' }, @subject.send(:data)[uuid])
      end
    end

    describe '#connected_uuids' do
      it 'returns connected UUIDs for a given resource' do
        reset
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

    private

    def reset
      WsConnectionStorage.instance.del(@subject.identifier)
    end
  end
end
