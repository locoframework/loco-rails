# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionStorageTest < TC
    before do
      @storage = WsConnectionStorage.current
      @storage.set('foo', 'bar')
      @raw = @storage.storage
    end

    describe '#get' do
      it do
        assert_equal 'bar', @storage.get('foo')
      end
    end

    describe '#del' do
      it do
        @storage.del('foo')
        assert_nil @storage.get('foo')
      end

      it 'deletes a hash' do
        @storage.set('foo1', 'bar' => 'buz')
        @storage.del('foo1')
        assert_nil @storage.get('foo1')
      end

      it "deletes a hash's key" do
        @storage.set('foo1', 'bar' => 'buz', 'baz' => 'faz')
        @storage.del('foo1', 'bar')
        assert_nil @storage.get('foo1', 'bar')
        assert_equal 'faz', @storage.get('foo1', 'baz')
      end
    end

    describe '#set' do
      it 'updates a value' do
        @storage.set('foo', 'baz')
        assert_equal 'baz', @storage.get('foo')
      end

      it 'can set a hash value' do
        @storage.set('foo1', 'bar' => 'buz')
        @storage.set('foo1', 'fuz' => 'faz')
        assert_equal 'buz', @storage.get('foo1', 'bar')
        assert_equal 'faz', @storage.get('foo1', 'fuz')
      end

      it 'can update a hash value' do
        @storage.set('foo1', 'bar' => 'new_buz')
        assert_equal 'new_buz', @storage.get('foo1', 'bar')
      end
    end

    describe '#scan' do
      before do
        @storage.set('key1', 'UUID#1' => '12345')
        @storage.set('key2', 'UUID#2' => '22345')
        @storage.set('key31', 'UUID#3' => '32345')
        @storage.set('key32', 'UUID#4' => '42345')
        @storage.set('key5', 'UUID#5' => '52345')
      end

      it 'accepts pattern' do
        res = {}
        @storage.scan(match: 'key3*') { |k, v| res[k] = v }
        assert_equal({ 'UUID#3' => '32345', 'UUID#4' => '42345' }, res)
      end
    end

    describe '#hlen' do
      before do
        @storage.set('key1', 'UUID#1' => '12345', 'UUID#2' => '22345')
      end

      it do
        assert_equal 2, @storage.hlen('key1')
      end
    end

    describe 'sets' do
      it 'works on a lower level' do
        @raw.sadd('sample-set', %w[foo bar])
        @raw.sadd('sample-set', 'bar')
        assert_equal %w[bar foo], @raw.smembers('sample-set')
        assert @raw.sismember('sample-set', 'foo')
        @raw.srem('sample-set', 'foo')
        assert_equal 1, @raw.scard('sample-set')
        assert @raw.exists?('sample-set')
        @raw.srem('sample-set', 'bar')
        assert_equal 'none', @raw.type('sample-set')
        assert_equal false, @raw.exists?('sample-set')
      end

      it 'works via the public interface' do
        @storage.add('key1', %w[foo bar])
        @storage.add('key1', 'bar')
        assert_equal %w[bar foo], @storage.members('key1')
      end
    end

    describe 'lists' do
      it 'works on a lower level' do
        @raw.rpush('sample-list', 'foo')
        assert_equal 'foo', @raw.lindex('sample-list', 0)
        @raw.rpushx('sample-list', 'bar')
        assert_equal 2, @raw.llen('sample-list')
        @raw.lset('sample-list', 1, 'baz')
        assert_equal %w[foo baz], @raw.lrange('sample-list', 0, 1)
        @raw.lrem('sample-list', 1, 'foo')
        assert_equal 'baz', @raw.lindex('sample-list', 0)
        @raw.lrem('sample-list', 1, 'baz')
        assert_equal 'none', @raw.type('sample-set')
        assert_equal false, @raw.exists?('sample-set')
      end
    end
  end
end
