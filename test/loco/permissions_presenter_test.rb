# frozen_string_literal: true

require 'test_helper'

module Loco
  class PermissionsPresenterTest < TC
    describe '#indexed' do
      it do
        uuid = SecureRandom.uuid
        res = PermissionsPresenter.indexed([uuid, users(:zbig), nil, admins(:one)])
        expected = { string: uuid, user: users(:zbig), admin: admins(:one) }
        assert_equal expected, res
      end
    end

    describe 'signed_in' do
      it do
        assert_equal [users(:zbig)], PermissionsPresenter.signed_in([nil, users(:zbig)])
      end
    end
  end
end
