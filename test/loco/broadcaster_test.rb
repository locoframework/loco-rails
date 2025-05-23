# frozen_string_literal: true

require 'test_helper'

module Loco
  class BroadcasterTest < TCWithMocks
    include WsHelpers

    COMPACT_OBJ = ['Article', 666, 'updated', { 'id' => 666 }].freeze

    describe '#emit' do
      before do
        setup_connections
        @time = Time.current
        @payload = { loco: { sync_time: @time.iso8601(6), notification: COMPACT_OBJ } }.freeze
      end

      it 'can emit to all' do
        allow_any_instance_of(Loco::Notification).to receive(:compact).and_return(COMPACT_OBJ)
        allow_any_instance_of(Loco::Notification).to receive(:created_at).and_return(@time)
        expect(SenderJob).to receive(:perform_later).with(:all, @payload)
        Broadcaster.(articles(:two), :updated, recipients: nil, payload: nil)
      end

      it 'can emit to a class of objects' do
        allow_any_instance_of(Loco::Notification).to receive(:compact).and_return(COMPACT_OBJ)
        allow_any_instance_of(Loco::Notification).to receive(:created_at).and_return(@time)
        expect(SenderJob).to receive(:perform_later).with({ 'class' => 'Admin::SupportMember' }, @payload)
        Broadcaster.(articles(:one), :created, recipients: [Admin::SupportMember], payload: nil)
        assert_equal 1, Notification.where(Notification::FOR_CLASS_SQL_TMPL, 'Admin::SupportMember').count
      end

      it 'can emit to a class of objects and a specific resource at the same time' do
        allow_any_instance_of(Loco::Notification).to receive(:compact).and_return(COMPACT_OBJ)
        allow_any_instance_of(Loco::Notification).to receive(:created_at).and_return(@time)
        expect(Sender).to receive(:call).with(users(:jane), @payload)
        expect(SenderJob).to receive(:perform_later).with({ 'class' => 'Admin::SupportMember' }, @payload)
        Broadcaster.(articles(:one), :created, recipients: [Admin::SupportMember, users(:jane)], payload: nil)
      end
    end
  end
end
