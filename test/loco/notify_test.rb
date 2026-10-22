# frozen_string_literal: true

require 'test_helper'

module Loco
  class NotifyTest < TCWithMocks
    include WsHelpers

    MESSAGE = { loco: { idempotency_key: 'abc', synced_at: '2026-10-13T10:00:00.000000Z' },
                type: 'updated', payload: {}, obj_class: 'Article', obj_id: 666 }.freeze

    describe '#emit' do
      before do
        setup_connections
        @payload = MESSAGE
      end

      it 'can emit to all' do
        allow(Notification::Presenter).to receive(:call).and_return(MESSAGE)
        expect(BroadcastJob).to receive(:perform_later).with(:all, @payload)
        Notify.(articles(:two), event: :updated, idempotency_key: 'k', recipients: nil, data: nil)
      end

      it 'can emit to a class of objects' do
        allow(Notification::Presenter).to receive(:call).and_return(MESSAGE)
        expect(BroadcastJob).to receive(:perform_later).with({ 'class' => 'Admin::SupportMember' }, @payload)
        Notify.(
          articles(:one), event: :created, idempotency_key: 'k', recipients: [Admin::SupportMember], data: nil
        )
        assert_equal 1, Notification.where(recipient_class: 'Admin::SupportMember', recipient_id: nil).count
      end

      it 'can emit to a class of objects and a specific resource at the same time' do
        allow(Notification::Presenter).to receive(:call).and_return(MESSAGE)
        sender = instance_double(Broadcast)
        expect(Broadcast).to receive(:new).with(users(:jane)).and_return(sender)
        expect(sender).to receive(:call).with(@payload)
        expect(BroadcastJob).to receive(:perform_later).with({ 'class' => 'Admin::SupportMember' }, @payload)
        Notify.(
          articles(:one), event: :created, idempotency_key: 'k', data: nil,
                          recipients: [Admin::SupportMember, users(:jane)]
        )
      end

      it 'sends to a token inline — one lookup, no fan-out' do
        allow(Notification::Presenter).to receive(:call).and_return(MESSAGE)
        sender = instance_double(Broadcast)
        expect(Broadcast).to receive(:new).with({ 'token' => 'tok' }).and_return(sender)
        expect(sender).to receive(:call).with(@payload)
        expect(BroadcastJob).not_to receive(:perform_later)
        Notify.(articles(:one), event: :created, idempotency_key: 'k', data: nil, recipients: 'tok')
      end
    end
  end
end
