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
        compact_resp = ['Article', 666, 'updated', { 'id' => 666 }]
        allow_any_instance_of(Loco::Notification).to receive(:compact).and_return(compact_resp)
        time = Time.current
        allow_any_instance_of(Loco::Notification).to receive(:created_at).and_return(time)
        expect(SenderJob).to receive(:perform_later).with(:all, loco: { notification: compact_resp })
        expect(SenderJob).to receive(:perform_later).with(:all, loco: { sync_time: time.iso8601(6) })
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
