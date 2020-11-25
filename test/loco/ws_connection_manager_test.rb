# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionManagerTest < TCWithMocks
    before do
      @user = users(:zbig)
      @identifier = WsConnectionIdentifier.call(@user)
      @storage = WsConnectionStorage.current
      @described_class = Loco::WsConnectionManager
      @subject = @described_class.new(@user)
    end

    describe 'checking connections' do
      before do
        @payload = { loco: { connection_check: true } }
        @org_expiration = WsConnectionManager::EXPIRATION
        WsConnectionManager::EXPIRATION = 1
      end

      after do
        WsConnectionManager::EXPIRATION = @org_expiration
      end

      it 'is run after add and del' do
        uuid1 = 'UUID#1'
        uuid2 = 'UUID#2'
        uuid3 = 'UUID#3'
        @subject.add(uuid1)
        @subject.add(uuid2)
        assert_equal 'ok', @storage.get(uuid1)

        expect(SenderJob).to receive(:perform_later).with(uuid1, @payload)
        expect(SenderJob).to receive(:perform_later).with(uuid2, @payload)
        sleep 2
        @subject.add(uuid3)
        assert_equal('verification', @storage.get(uuid2))
        assert_equal 3, @storage.members(@identifier).size

        @subject.del(uuid2)
        assert_equal('verification', @storage.get(uuid1))
        assert_nil @storage.get(uuid2)
        assert_equal 'ok', @storage.get(uuid3)
      end
    end

    describe '#add' do
      it 'adds UUID and it is considered connected' do
        @subject.add('uuid1')
        assert_equal 'ok', @subject.send(:connection_status, 'uuid1')
      end
    end

    describe '#del' do
      it do
        @subject.add('uuid1')
        @subject.del('uuid1')
        assert_nil @subject.send(:connection_status, 'uuid1')
      end
    end

    describe '#update' do
      it do
        @subject.add('uuid1')
        @storage.set('h:uuid1', 'tmp-state')
        @subject.update('uuid1')
        assert @subject.send(:connection_status, 'uuid1')
      end
    end

    describe 'private #identifier' do
      it 'returns a correct format of an identifier' do
        assert_equal "user:#{@user.id}", @subject.send(:identifier)
        assert_equal 'foo', @described_class.new('foo').send(:identifier)
      end
    end
  end
end
