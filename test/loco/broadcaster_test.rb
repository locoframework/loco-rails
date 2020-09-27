# frozen_string_literal: true

require 'test_helper'

module Loco
  class BroadcasterTest < TCWithMocks
    include WsHelpers

    describe '#emit' do
      before do
        create_connection(users(:zbig))
        create_connection(users(:jane))
        create_connection(admins(:one))
        create_connection(admins(:one))
        @loco_params = { loco: { xhr_notifications: true } }
      end

      it 'can emit to all' do
        expect(SenderJob).to receive(:perform_later).exactly(4).times
        Broadcaster.call(articles(:two), :updated)
      end

      it 'can emit to a class of objects' do
        mgr = WsConnectionManager.new(admins(:one))
        expect(SenderJob).to receive(:perform_later).with(mgr.connected_uuids[0], @loco_params)
        expect(SenderJob).to receive(:perform_later).with(mgr.connected_uuids.last, @loco_params)
        Broadcaster.call(articles(:one), :created, recipients: [Admin])
        assert_equal 1, Notification.where(Notification::FOR_CLASS_SQL_TMPL, 'Admin').count
      end
    end
  end
end
