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
  end
end
