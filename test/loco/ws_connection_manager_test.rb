# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionManagerTest < TCWithMocks
    include WsHelpers

    before do
      @user = users(:zbig)
      @described_class = Loco::WsConnectionManager
      @subject = @described_class.new(@user)
      reset_connections(@user)
    end

    describe 'checking connections' do
      it 'is run after add and del' do
        uuid1 = SecureRandom.uuid
        uuid2 = SecureRandom.uuid
        uuid3 = SecureRandom.uuid
        time = Time.utc(2020, 0o1, 0o1, 11, 30)
        travel_to(time) { @subject.add(uuid1) }
        travel_to(time + (3 * 60 - 1).seconds) { @subject.add(uuid2) }
        assert_equal '2020-01-01T11:30:00.000000Z', @subject.send(:data)[uuid1]

        payload = { loco: { connection_check: true } }
        expect(SenderJob).to receive(:perform_later).with(uuid1, payload)
        travel_to(time + (3 * 60 + 1).seconds) { @subject.add(uuid3) }
        assert_equal({ 'check' => '2020-01-01T11:33:01.000000Z' }, @subject.send(:data)[uuid1])
        assert_equal 3, @subject.send(:data).keys.size

        travel_to(time + (3 * 60 + 1 + 6).seconds) { @subject.del(uuid2) }
        assert_equal({ uuid3 => '2020-01-01T11:33:01.000000Z' }, @subject.send(:data))
      end
    end

    describe '#add' do
      it 'adds UUID and it is considered connected' do
        uuid = SecureRandom.uuid
        travel_to Time.utc(2020) do
          @subject.add(uuid)
        end
        assert @subject.connected?(uuid)
      end
    end

    describe '#connected_uuids' do
      it 'returns connected UUIDs for a given resource' do
        uuid = SecureRandom.uuid
        @subject.add(uuid)
        assert_equal [uuid], @subject.connected_uuids
      end
    end

    describe '#del' do
      # tested in 'checking connections'
    end

    describe '#identifier' do
      it 'returns a correct format of an identifier' do
        assert_equal "user:#{@user.id}", @subject.identifier
        assert_equal 'foo', @described_class.new('foo').identifier
      end
    end
  end
end
