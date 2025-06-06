# frozen_string_literal: true

module Loco
  class Broadcaster
    class << self
      def call(obj, event, recipients:, payload:)
        data = Payload.(payload)
        process_recipients(recipients).each do |recipient|
          notification = Notification.create!(
            obj:,
            event:,
            recipient:,
            data:
          )
          sync_time = notification.created_at.iso8601(6)
          send_notification(keify_recipient(recipient), notification, sync_time)
        end
      end

      private

      def process_recipients(recipients)
        return [:all] if recipients.nil?

        recipients = [recipients] unless recipients.is_a?(Array)
        recipients = recipients.map { |e| e.nil? ? :all : e }
        return [:all] if recipients.include?(:all)

        recipients.map do |recipient|
          if recipient.is_a?(Hub)
            recipient.members(shallow: true)
          else
            recipient
          end
        end.flatten
      end

      def keify_recipient(recipient)
        case recipient
        when String then { 'token' => recipient }
        when Class then { 'class' => recipient.name }
        else recipient
        end
      end

      def send_notification(recipient, notification, sync_time)
        payload = { loco: { sync_time:, notification: notification.compact } }
        if notification.recipient_id
          Sender.(recipient, payload)
        else
          SenderJob.perform_later(recipient, payload)
        end
      end
    end
  end
end
