# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionManagerTest < TC
    before do
      @user = users(:zbig)
      @identifier = WsConnectionIdentifier.(@user)
      @storage = WsConnectionStorage.instance
      @subject = WsConnectionManager.new(@user)
    end

    describe '#add' do
      it 'adds UUID and it is considered connected' do
        @subject.add('uuid1')
        assert_equal 'ok', @storage.get('uuid1')
        assert_equal ['uuid1'], @storage.members(@identifier)
      end
    end

    describe '#del' do
      it 'deletes a key' do
        @subject.add('uuid1')
        @subject.del('uuid1')
        assert_nil @storage.get('uuid1')
        assert_empty @storage.members(@identifier)
      end
    end

    describe '#update' do
      it 'refreshes the connection state' do
        @subject.add('uuid1')
        @storage.set('uuid1', 'tmp-state')
        @subject.update('uuid1')
        assert_equal 'ok', @storage.get('uuid1')
      end
    end

    describe 'stale connections' do
      before do
        @org_expiration = WsConnectionManager::EXPIRATION
        Kernel.silence_warnings { WsConnectionManager::EXPIRATION = 1 }
      end

      after do
        Kernel.silence_warnings { WsConnectionManager::EXPIRATION = @org_expiration }
      end

      it 'keeps fresh connections' do
        @subject.add('uuid1')
        @subject.add('uuid2')
        assert_equal %w[uuid1 uuid2], @storage.members(@identifier).sort
        assert_equal 'ok', @storage.get('uuid1')
      end

      it 'drops connections whose state has expired' do
        @subject.add('uuid1')
        sleep 2
        @subject.add('uuid2')
        assert_equal ['uuid2'], @storage.members(@identifier)
        assert_empty @storage.members('uuid:uuid1')
      end

      it 'sweeps the remaining stale connections on del too' do
        @subject.add('uuid1')
        @subject.add('uuid2')
        sleep 2
        @subject.del('uuid1')
        assert_empty @storage.members(@identifier)
        assert_empty @storage.members('uuid:uuid2')
      end

      it 'skips the sweep when asked — this is what stops del from recursing' do
        @subject.add('uuid1')
        @subject.add('uuid2')
        sleep 2
        @subject.del('uuid1', skip_checker: true)
        assert_equal ['uuid2'], @storage.members(@identifier)
      end
    end

    describe 'private #identifier' do
      it 'returns a correct format of an identifier' do
        assert_equal "user:#{@user.id}", @subject.send(:identifier)
        assert_equal 'foo', WsConnectionManager.new('foo').send(:identifier)
      end
    end
  end
end
