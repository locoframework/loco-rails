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
      @storage.set('random-token', 'UUID#6' => '62345')
    end

    describe '#call' do
      before do
        @res = []
      end

      it 'finds connections of defined resources' do
        WsConnectionFinder.call([users(:zbig), Admin]) { |uuid, _| @res << uuid }
        assert_equal(['UUID#1', 'UUID#3', 'UUID#4'], @res.sort)
      end

      it 'returns all UUIDs if :all is passed' do
        WsConnectionFinder.call(:all) { |uuid, _| @res << uuid }
        assert_equal(['UUID#1', 'UUID#2', 'UUID#3', 'UUID#4', 'UUID#5', 'UUID#6'], @res.sort)
      end

      it 'supports string as an argument' do
        WsConnectionFinder.call('random-token') { |uuid, _| @res << uuid }
        assert_equal(['UUID#6'], @res)
      end
    end
  end
end
