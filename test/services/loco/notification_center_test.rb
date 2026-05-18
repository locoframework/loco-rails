# frozen_string_literal: true

require 'test_helper'

module Loco
  class NotificationCenterTest < TCWithMocks
    describe '#received_message' do
      describe 'PING' do
        let(:zbig) { users(:zbig) }
        let(:admin) { admin_support_members(:one) }
        let(:payload) { { 'type' => 'PING', 'user_id' => zbig.id } }

        it 'emits PING back to the target user when sender is an admin' do
          expect(Loco).to receive(:emit).with(
            { type: 'PING' },
            to: have_attributes(id: zbig.id),
            ws_only: true
          )
          NotificationCenter.new.received_message({ 'admin/support_member': admin }, payload)
        end

        it 'ignores PING when sender is not an admin' do
          expect(Loco).not_to receive(:emit)
          NotificationCenter.new.received_message({ user: zbig }, payload)
        end

        it 'ignores PING when no permissions are present' do
          expect(Loco).not_to receive(:emit)
          NotificationCenter.new.received_message({}, payload)
        end
      end
    end
  end
end
