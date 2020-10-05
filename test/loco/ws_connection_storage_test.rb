# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionStorageTest < TC
    before do
      @storage = WsConnectionStorage.current
      @storage.set('foo', 'bar')
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
    end

    describe '#set' do
      it 'updates a value' do
        @storage.set('foo', 'baz')
        assert_equal 'baz', @storage.get('foo')
      end

      it 'can set a hash value' do
        @storage.set('foo1', 'bar' => 'buz')
        assert_equal 'buz', @storage.get('foo1', 'bar')
      end

      it 'can update a hash value' do
        @storage.set('foo1', 'bar' => 'new_buz')
        assert_equal 'new_buz', @storage.get('foo1', 'bar')
      end
    end

    describe '#find' do
      before do
        @storage.set('user:159163583', 'UUID#1' => '12345')
        @storage.set('user:980204181', 'UUID#2' => '22345')
        @storage.set('admin:980190962', 'UUID#3' => '32345')
        @storage.set('admin:880190960', 'UUID#4' => '42345')
        @storage.set('comment:980190961', 'UUID#5' => '52345')
      end

      it 'accepts pattern' do
        res = {}
        @storage.find(match: 'admin:*') { |k, v| res[k] = v }
        assert_equal({ 'UUID#3' => '32345', 'UUID#4' => '42345' }, res)
      end
    end
  end
end
