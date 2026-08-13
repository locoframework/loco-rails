# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionStorageTest < TC
    before do
      @storage = WsConnectionStorage.instance
      @storage.set('foo', 'bar')
    end

    describe '#get' do
      it do
        assert_equal 'bar', @storage.get('foo')
      end
    end

    describe '#set' do
      it 'updates a value' do
        @storage.set('foo', 'baz')
        assert_equal 'baz', @storage.get('foo')
      end

      it 'expires a value' do
        @storage.set('foo', 'bar', ex: 1)
        sleep 2
        assert_nil @storage.get('foo')
      end
    end

    describe '#del' do
      it do
        @storage.del('foo')
        assert_nil @storage.get('foo')
      end
    end

    describe '#scan' do
      before do
        @storage.add('key1', 'UUID#1')
        @storage.add('key31', 'UUID#3')
        @storage.add('key32', 'UUID#4')
        @storage.add('key2', 'UUID#2')
      end

      it 'accepts pattern' do
        res = []
        @storage.scan(match: 'key3*') { |v| res << v }
        assert_equal(['UUID#3', 'UUID#4'], res.sort)
      end
    end

    describe 'sets' do
      it 'adds, reads and removes members' do
        @storage.add('key1', %w[foo bar])
        @storage.add('key1', 'bar')
        assert_equal %w[bar foo], @storage.members('key1').sort
        assert @storage.member?('key1', 'foo')
        @storage.rem('key1', 'foo')
        assert_equal false, @storage.member?('key1', 'foo')
      end

      it 'deletes a whole set' do
        @storage.add('key1', 'foo')
        @storage.del_set('key1')
        assert_empty @storage.members('key1')
        assert_equal 'none', @storage.type('s:key1')
      end
    end
  end
end
