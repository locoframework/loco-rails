# frozen_string_literal: true

module Loco
  class Broadcaster
    class << self
      def call(obj, event, recipients: nil, payload: nil)
        payload ||= {}
        payload[:loco] = { idempotency_key: SecureRandom.hex }
        processed_recips = process_recipients(recipients)
        init_notifications(obj, event, processed_recips, payload).each do |recipient, notification|
          sync_time = notification.created_at.iso8601(6)
          SenderJob.perform_later(recipient, loco: { notification: notification.compact })
          SenderJob.perform_later(recipient, loco: { sync_time: sync_time })
        end
      end

      private

      def process_recipients(recipients)
        recipients = [:all] if recipients.nil?
        recipients = [recipients] unless recipients.is_a?(Array)
        recipients = recipients.map { |e| e.nil? ? :all : e }
        recipients = [:all] if recipients.include?(:all)
        recipients
      end

      def init_notifications(obj, event, recipients, payload)
        recipients.each_with_object({}) do |recipient, hash|
          key = keify_recipient(recipient)
          hash[key] = Notification.create!(obj: obj, event: event, recipient: recipient, data: payload)
        end
      end

      def keify_recipient(recipient)
        case recipient
        when String then { 'token' => recipient }
        when Class then { 'class' => recipient.name }
        else recipient
        end
      end
    end
  end
end
