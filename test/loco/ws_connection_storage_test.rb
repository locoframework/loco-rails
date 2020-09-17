# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionStorageTest < TC
    before do
      Loco::WsConnectionStorage.current.set('foo', 'bar')
    end

    describe '#get' do
      it do
        assert_equal 'bar', Loco::WsConnectionStorage.current.get('foo')
      end
    end

    describe '#del' do
      it do
        Loco::WsConnectionStorage.current.del('foo')
        assert_nil Loco::WsConnectionStorage.current.get('foo')
      end
    end
  end
end
