# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionManagerTest < TCWithMocks
    before do
      @user = users(:zbig)
      @identifier = WsConnectionIdentifier.(@user)
      @storage = WsConnectionStorage.current
      @described_class = Loco::WsConnectionManager
      @subject = @described_class.new(@user)
    end

    describe 'initialization' do
      it 'can accept an identifier' do
        assert_equal 'foo', @described_class.new('foo', identifier: true).send(:identifier)
      end
    end

    describe 'checking connections' do
      before do
        @payload = { loco: { ping: true } }
        @org_expiration = WsConnectionManager::EXPIRATION
        Kernel.silence_warnings { WsConnectionManager::EXPIRATION = 1 }
      end

      after do
        Kernel.silence_warnings { WsConnectionManager::EXPIRATION = @org_expiration }
      end

      it 'is run after add and del' do
        uuid1 = 'UUID#1'
        uuid2 = 'UUID#2'
        uuid3 = 'UUID#3'
        @subject.add(uuid1)
        @subject.add(uuid2)
        assert_equal 'ok', @storage.get(uuid1)

        expect(Sender).to receive(:call).with(uuid1, @payload)
        expect(Sender).to receive(:call).with(uuid2, @payload)
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
        assert_equal 'ok', WsConnectionStorage.current.get('uuid1')
      end
    end

    describe '#del' do
      it 'deletes a key' do
        @subject.add('uuid1')
        @subject.del('uuid1')
        assert_nil WsConnectionStorage.current.get('uuid1')
      end

      it 'calls out a checker' do
        expect(WsConnectionChecker).to receive(:call).with("user:#{@user.id}")
        @subject.del('uuid1')
      end

      it 'can skip triggering a checker"' do
        expect(WsConnectionChecker).to_not receive(:call)
        @subject.del('uuid1', skip_checker: true)
      end
    end

    describe '#update' do
      it do
        @subject.add('uuid1')
        @storage.set('h:uuid1', 'tmp-state')
        @subject.update('uuid1')
        assert_equal 'ok', WsConnectionStorage.current.get('uuid1')
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
