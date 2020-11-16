# frozen_string_literal: true

require 'test_helper'

module Loco
  class BroadcasterTest < TCWithMocks
    include WsHelpers

    COMPACT_OBJ = ['Article', 666, 'updated', { 'id' => 666 }].freeze
    PAYLOAD = { loco: { notification: COMPACT_OBJ } }.freeze

    describe '#emit' do
      before do
        setup_connections
        @time = Time.current
        @sync_time_payload = { loco: { sync_time: @time.iso8601(6) } }
      end

      it 'can emit to all' do
        allow_any_instance_of(Loco::Notification).to receive(:compact).and_return(COMPACT_OBJ)
        allow_any_instance_of(Loco::Notification).to receive(:created_at).and_return(@time)
        expect(SenderJob).to receive(:perform_later).with(:all, PAYLOAD)
        expect(SenderJob).to receive(:perform_later).with(:all, @sync_time_payload)
        Broadcaster.call(articles(:two), :updated)
      end

      it 'can emit to a class of objects' do
        allow_any_instance_of(Loco::Notification).to receive(:compact).and_return(COMPACT_OBJ)
        allow_any_instance_of(Loco::Notification).to receive(:created_at).and_return(@time)
        expect(SenderJob).to receive(:perform_later).with({ 'class' => 'Admin' }, PAYLOAD)
        expect(SenderJob).to receive(:perform_later).with({ 'class' => 'Admin' }, @sync_time_payload)
        Broadcaster.call(articles(:one), :created, recipients: [Admin])
        assert_equal 1, Notification.where(Notification::FOR_CLASS_SQL_TMPL, 'Admin').count
      end

      it 'can emit to a class of objects and a specific resource at the same time' do
        allow_any_instance_of(Loco::Notification).to receive(:compact).and_return(COMPACT_OBJ)
        allow_any_instance_of(Loco::Notification).to receive(:created_at).and_return(@time)
        expect(SenderJob).to receive(:perform_later).with(users(:jane), PAYLOAD)
        expect(SenderJob).to receive(:perform_later).with(users(:jane), @sync_time_payload)
        expect(SenderJob).to receive(:perform_later).with({ 'class' => 'Admin' }, PAYLOAD)
        expect(SenderJob).to receive(:perform_later).with({ 'class' => 'Admin' }, @sync_time_payload)
        Broadcaster.call(articles(:one), :created, recipients: [Admin, users(:jane)])
      end
    end
  end
end
