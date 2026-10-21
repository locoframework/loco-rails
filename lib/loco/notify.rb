# frozen_string_literal: true

module Loco
  class Notify
    class << self
      def call(obj, recipients:, event:, idempotency_key:, data:)
        process_recipients(recipients).each do |recipient|
          notification = Notification.create!(obj:, event:, idempotency_key:, recipient:, data:)
          send_notification(keify_recipient(recipient), notification)
        end
      end

      private

      def process_recipients(recipients)
        recipients = [recipients] unless recipients.is_a?(Array)
        if recipients.any? { _1.nil? || _1 == :all }
          [:all]
        else
          recipients.flat_map { _1.is_a?(Hub) ? _1.members(shallow: true) : _1 }
        end
      end

      def keify_recipient(recipient)
        case recipient
        when String then { 'token' => recipient }
        when Class then { 'class' => recipient.name }
        else recipient
        end
      end

      def send_notification(recipient, notification)
        presenter = Notification::Presenter.(notification)
        if notification.recipient_id || notification.recipient_token
          Broadcast.new(recipient).(presenter)
        else
          BroadcastJob.perform_later(recipient, presenter)
        end
      end
    end
  end
end
