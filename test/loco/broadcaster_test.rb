# frozen_string_literal: true

require 'test_helper'

module Loco
  class BroadcasterTest < TCWithMocks
    include WsHelpers

    SYNC_TIME = '2026-10-13T10:00:00.000000Z'
    COMPACT_OBJ = ['Article', 666, 'updated', { 'id' => 666 }, SYNC_TIME].freeze

    describe '#emit' do
      before do
        setup_connections
        @payload = { loco: { sync_time: SYNC_TIME, notification: COMPACT_OBJ } }.freeze
      end

      it 'can emit to all' do
        allow_any_instance_of(Loco::Notification).to receive(:compact).and_return(COMPACT_OBJ)
        expect(SenderJob).to receive(:perform_later).with(:all, @payload)
        Broadcaster.(articles(:two), :updated, recipients: nil, data: nil)
      end

      it 'can emit to a class of objects' do
        allow_any_instance_of(Loco::Notification).to receive(:compact).and_return(COMPACT_OBJ)
        expect(SenderJob).to receive(:perform_later).with({ 'class' => 'Admin::SupportMember' }, @payload)
        Broadcaster.(articles(:one), :created, recipients: [Admin::SupportMember], data: nil)
        assert_equal 1, Notification.where(recipient_class: 'Admin::SupportMember', recipient_id: nil).count
      end

      it 'can emit to a class of objects and a specific resource at the same time' do
        allow_any_instance_of(Loco::Notification).to receive(:compact).and_return(COMPACT_OBJ)
        sender = instance_double(Sender)
        expect(Sender).to receive(:new).with(users(:jane)).and_return(sender)
        expect(sender).to receive(:call).with(@payload)
        expect(SenderJob).to receive(:perform_later).with({ 'class' => 'Admin::SupportMember' }, @payload)
        Broadcaster.(articles(:one), :created, recipients: [Admin::SupportMember, users(:jane)], data: nil)
      end
    end
  end
end
