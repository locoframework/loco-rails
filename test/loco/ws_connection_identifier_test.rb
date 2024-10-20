# frozen_string_literal: true

require 'test_helper'

module Admin
  class MemberUser
    def id
      123
    end
  end
end

module Loco
  class WsConnectionIdentifierTest < TC
    describe '#call' do
      it 'returns a string for a string' do
        assert_equal 'string', WsConnectionIdentifier.('string')
      end

      it 'returns a underscored class name for a class' do
        assert_equal 'admin/member_user', WsConnectionIdentifier.(Admin::MemberUser)
      end

      it 'returns a string with underscored class name and id for an object' do
        assert_equal 'admin/member_user:123', WsConnectionIdentifier.(Admin::MemberUser.new)
      end
    end
  end
end
