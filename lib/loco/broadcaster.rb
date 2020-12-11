# frozen_string_literal: true

module Loco
  class Broadcaster
    class << self
      def call(obj, event, recipients: nil, payload: nil)
        payload ||= {}
        payload[:loco] = { idempotency_key: SecureRandom.hex }
        send_notifications(obj, event, process_recipients(recipients), payload)
      end

      private

      def process_recipients(recipients)
        recipients = [:all] if recipients.nil?
        recipients = [recipients] unless recipients.is_a?(Array)
        recipients = recipients.map { |e| e.nil? ? :all : e }
        recipients = [:all] if recipients.include?(:all)
        recipients
      end

      def send_notifications(obj, event, recipients, payload)
        recipients.each do |recipient|
          notification = Notification.create!(
            obj: obj,
            event: event,
            recipient: recipient,
            data: payload
          )
          sync_time = notification.created_at.iso8601(6)
          send_notification(keify_recipient(recipient), notification, sync_time)
        end
      end

      def keify_recipient(recipient)
        case recipient
        when String then { 'token' => recipient }
        when Class then { 'class' => recipient.name }
        else recipient
        end
      end

      def send_notification(recipient, notification, sync_time)
        if notification.recipient_id
          Sender.(recipient, loco: { notification: notification.compact })
          Sender.(recipient, loco: { sync_time: sync_time })
        else
          SenderJob.perform_later(recipient, loco: { notification: notification.compact })
          SenderJob.perform_later(recipient, loco: { sync_time: sync_time })
        end
      end
    end
  end
end
