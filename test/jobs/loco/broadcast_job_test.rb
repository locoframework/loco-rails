# frozen_string_literal: true

require 'test_helper'

module Loco
  # a job that waits in the queue must not be skipped by a sync point that moved
  # past its row's `created_at` in the meantime
  class BroadcastJobTest < TCWithMocks
    test 'restamps only the row it broadcasts, and fetches it past an earlier sync point' do
      travel_to(1.minute.ago) do
        Notify.(articles(:one), event: :created, idempotency_key: 'k', data: nil,
                                recipients: [Admin::SupportMember, User])
      end
      synced_at = 30.seconds.ago.iso8601(6)
      payload = Notification::Presenter.(Notification.find_by!(recipient_class: 'User'))
      broadcast = instance_double(Broadcast)
      expect(Broadcast).to receive(:new).with({ 'class' => 'User' }).and_return(broadcast)
      expect(broadcast).to receive(:call) { |sent| assert_operator sent[:loco][:synced_at], :>, synced_at }

      ActiveJob::Base.execute(BroadcastJob.new({ 'class' => 'User' }, payload).serialize)

      fetched = Notification::Fetch.(synced_at:, permissions: [User, Admin::SupportMember], recipient_token: nil)
      assert_equal 1, fetched[:notifications].size
    end
  end
end
