# frozen_string_literal: true

require 'test_helper'

module Loco
  class HubTest < TC
    describe '#add_member' do
      it 'returns members' do
        hub = Hub.set('foobar', [users(:zbig)])
        hub.add_member(users(:jane))
        assert_equal [users(:jane), users(:zbig)], hub.members
      end
    end

    describe '#del_member' do
      it 'returns members' do
        hub = Hub.set('foobar', [users(:zbig), users(:jane)])
        hub.del_member(users(:jane))
        assert_equal [users(:zbig)], hub.members
      end
    end

    describe '#destroy' do
      it 'destroys' do
        hub = Hub.set('foobar', [users(:zbig), users(:jane)])
        assert_equal 'foobar', Hub.get('foobar').name
        hub.destroy
        assert_nil Hub.get('foobar')
      end
    end

    describe '#include?' do
      it do
        hub = Hub.set('foobar', [users(:zbig)])
        assert hub.include?(users(:zbig))
        assert_equal hub.include?(users(:jane)), false
      end
    end

    describe '#members' do
      it 'returns members' do
        hub = Hub.set('foobar', [users(:zbig), users(:jane)])
        assert_equal [users(:jane), users(:zbig)], hub.members
      end
    end

    describe '#name' do
      it 'returns a name' do
        hub = Hub.set('foobar', [users(:zbig), users(:jane)])
        assert_equal 'foobar', hub.name
      end
    end
  end
end
