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
    end

    describe '#set' do
      it 'can set a hash value' do
        @storage.set('foo1', 'bar' => 'buz')
        assert_equal 'buz', @storage.get('foo1', 'bar')
      end
    end
  end
end
