# frozen_string_literal: true

require 'test_helper'

module Loco
  class PermissionsPresenterTest < TC
    describe '#indexed' do
      before do
        @uuid = SecureRandom.uuid
      end

      it 'returns objects indexed by their type' do
        res = PermissionsPresenter.indexed([@uuid, users(:zbig), nil, admin_support_members(:one)])
        expected = { string: @uuid, user: users(:zbig), :"admin/support_member" => admin_support_members(:one) }
        assert_equal expected, res
      end

      it 'does not return string if except: uuid is passed' do
        loco_permissions = [@uuid, users(:zbig), nil, admin_support_members(:one)]
        res = PermissionsPresenter.indexed(loco_permissions, except: :uuid)
        expected = { user: users(:zbig), :"admin/support_member" => admin_support_members(:one) }
        assert_equal expected, res
      end
    end

    describe 'signed_in' do
      it 'acts as compact' do
        assert_equal [users(:zbig)], PermissionsPresenter.signed_in([nil, users(:zbig)])
      end

      it 'accepts except: uuid' do
        permissions = [nil, users(:zbig), 'foo']
        assert_equal [users(:zbig)], PermissionsPresenter.signed_in(permissions, except: :uuid)
      end
    end
  end
end
