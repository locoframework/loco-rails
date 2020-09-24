# frozen_string_literal: true

module Loco
  class Broadcaster
    def initialize
      @notifications = []
      @sent_via_ws = 0
    end

    def emit(obj, event, recipients:, payload: nil)
      init_notifications(obj, event, recipients, payload)
      send_notifications(WsConnectedResourcesManager.new(recipients.compact))
      if notify_about_xhr_notifications?
        notify_about_xhr_notifications
      else
        set_sync_time_via_ws
      end
    end

    private

    def init_notifications(obj, event, recipients, payload)
      @notification = []
      recipients.each do |recipient|
        @notifications << Notification.new(
          obj: obj,
          event: event,
          recipient: recipient,
          data: payload
        )
      end
    end

    def send_notifications(conn_res_manager)
      @notifications.each do |notification|
        notification.save!
        next if notification.recipient_id.nil?

        shallow_recipient = notification.recipient(shallow: true)
        next unless conn_res_manager.connected?(shallow_recipient)

        send_via_ws(notification)
      end
    end

    def send_via_ws(notification)
      recipient = notification.recipient(shallow: true)
      SenderJob.perform_later(recipient, { loco: { notification: notification.compact } })
      @sent_via_ws += 1
    end

    def notify_about_xhr_notifications?
      @sent_via_ws < @notifications.size
    end

    def notify_about_xhr_notifications
      uuids = []
      fetch_identifiers.each do |ident|
        Loco::WsConnectionManager.new(ident).connected_uuids.each do |uuid|
          next if uuids.include?(uuid)

          uuids << uuid
          SenderJob.perform_later(uuid, loco: { xhr_notifications: true })
        end
      end
    end

    def set_sync_time_via_ws
      sync_time = @notifications.last.created_at.iso8601(6)
      @notifications.each do |notification|
        recipient = notification.recipient(shallow: true)
        SenderJob.perform_later(recipient, loco: { sync_time: sync_time })
      end
    end

    def notifications_recipients
      @notifications
        .map { |n| n.recipient(shallow: true) }
        .map { |o| o.instance_of?(Class) ? o.to_s.downcase : nil }
    end

    def fetch_identifiers
      recipients = notifications_recipients
      uniq_recipients = recipients.compact.uniq
      WsConnectedResourcesManager.identifiers.find_all do |str|
        if recipients.include?(nil)
          true
        else
          uniq_recipients.include?(str.split(':').first)
        end
      end
    end
  end
end
