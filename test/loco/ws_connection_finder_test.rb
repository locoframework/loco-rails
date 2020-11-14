# frozen_string_literal: true

require 'test_helper'

module Loco
  class WsConnectionFinderTest < TC
    include WsHelpers

    before do
      create_connection(users(:zbig), 'UUID#1')
      create_connection(users(:jane), 'UUID#2')
      create_connection(admins(:one), 'UUID#3')
      create_connection(admins(:two), 'UUID#4')
      create_connection('comment:980190961', 'UUID#5')
      create_connection('random-token', 'UUID#6')
      Hub.new('foobar', [users(:zbig), users(:jane)]).save
    end

    describe '#call' do
      before do
        @res = []
      end

      it 'finds connections of defined resources' do
        WsConnectionFinder.call([users(:zbig), Admin]) { |uuid| @res << uuid }
        assert_equal(['UUID#1', 'UUID#3', 'UUID#4'], @res.sort)
      end

      it 'returns all UUIDs if :all is passed' do
        WsConnectionFinder.call(:all) { |uuid| @res << uuid }
        assert_equal(['UUID#1', 'UUID#2', 'UUID#3', 'UUID#4', 'UUID#5', 'UUID#6'], @res.sort)
      end

      it 'supports string as an argument' do
        WsConnectionFinder.call('random-token') { |uuid| @res << uuid }
        assert_equal(['UUID#6'], @res)
      end
    end
  end
end
