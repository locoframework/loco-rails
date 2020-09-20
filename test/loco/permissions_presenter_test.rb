# frozen_string_literal: true

require 'test_helper'

module Loco
  class PermissionsPresenterTest < TC
    describe '#indexed' do
      it do
        uuid = SecureRandom.uuid
        res = PermissionsPresenter.indexed([uuid, users(:user_zbig), nil, admins(:one)])
        expected = { string: uuid, user: users(:user_zbig), admin: admins(:one) }
        assert_equal expected, res
      end
    end
  end
end
