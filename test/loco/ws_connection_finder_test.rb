# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionFinderTest < TC
    include WsHelpers

    before do
      setup_connections
    end

    describe '#call' do
      before do
        @res = []
      end

      it 'finds connections of defined resources' do
        WsConnectionFinder.([users(:zbig), Admin::SupportMember]) { |uuid| @res << uuid }
        assert_equal(['UUID#1', 'UUID#3', 'UUID#3.1', 'UUID#4'], @res.sort)
      end

      it 'returns all UUIDs if :all is passed' do
        WsConnectionFinder.(:all) { |uuid| @res << uuid }
        assert_equal(%w[UUID#1 UUID#2 UUID#3 UUID#3.1 UUID#4 UUID#5 UUID#6], @res.sort)
      end

      it 'supports string as an argument' do
        WsConnectionFinder.('random-token') { |uuid| @res << uuid }
        assert_equal(['UUID#6'], @res)
      end

      it 'finds connections for a Hub' do
        WsConnectionFinder.(Hub.get('foobar')) { |uuid| @res << uuid }
        assert_equal(['UUID#2', 'UUID#1'].sort, @res.sort)
      end
    end
  end
end
