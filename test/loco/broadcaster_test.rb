# frozen_string_literal: true

require 'test_helper'

module Loco
  class BroadcasterTest < TCWithMocks
    include WsHelpers

    describe '#emit' do
      it 'can emit to a class of objects' do
        create_connection(users(:zbig))
        create_connection(users(:jane))
        create_connection(admins(:one))
        mgr = WsConnectionManager.new(admins(:one))
        loco_params = { loco: { xhr_notifications: true } }
        expect(SenderJob).to receive(:perform_later).with(mgr.connected_uuids.first, loco_params)
        Broadcaster.call(articles(:one), :created, recipients: [Admin])
        assert_equal 1, Notification.where(Notification::FOR_CLASS_SQL_TMPL, 'Admin').count
      end
    end
  end
end
