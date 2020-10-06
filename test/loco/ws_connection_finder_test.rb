# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionFinderTest < TC
    before do
      @storage = WsConnectionStorage.current
      @storage.set("user:#{users(:zbig).id}", 'UUID#1' => '12345')
      @storage.set("user:#{users(:jane).id}", 'UUID#2' => '22345')
      @storage.set("admin:#{admins(:one).id}", 'UUID#3' => '32345')
      @storage.set("admin:#{admins(:two).id}", 'UUID#4' => '42345')
      @storage.set('comment:980190961', 'UUID#5' => '52345')
    end

    describe '#call' do
      it do
        res = []
        WsConnectionFinder.call([users(:zbig), Admin]) { |uuid, _| res << uuid }
        assert_equal(['UUID#1', 'UUID#3', 'UUID#4'], res.sort)
      end
    end
  end
end
