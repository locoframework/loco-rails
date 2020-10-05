# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionFinderTest < TC
    before do
      @storage = WsConnectionStorage.current
      @storage.set("user:#{users(:zbig).id}", 'UUID#1')
      @storage.set("user:#{users(:jane).id}", 'UUID#2')
      @storage.set("admin:#{admins(:one).id}", 'UUID#3')
      @storage.set("admin:#{admins(:two).id}", 'UUID#4')
      @storage.set('comment:980190961', 'UUID#5')
    end

    describe '#find' do
      it do
        res = []
        WsConnectionFinder.call([users(:zbig), Admin]) { |v| res << v }
        assert_equal(['UUID#1', 'UUID#3', 'UUID#4'], res.sort)
      end
    end
  end
end
