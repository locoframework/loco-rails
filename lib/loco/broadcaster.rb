# frozen_string_literal: true

module Loco
  class Broadcaster
    def emit(obj, event, recipients:, payload: nil)
      notifications = init_notifications(obj, event, recipients, payload)
      conn_res_manager = WsConnectedResourcesManager.new(recipients.compact)
      sent = send_notifications(notifications, conn_res_manager)
      if sent < notifications.size
        notify_about_xhr_notifications(notifications_recipients(notifications))
      else
        sync_time_via_ws(notifications)
      end
    end

    private

    def init_notifications(obj, event, recipients, payload)
      recipients.map do |recipient|
        Notification.new(obj: obj, event: event, recipient: recipient, data: payload)
      end
    end

    def send_notifications(notifications, conn_res_manager)
      notifications.inject(0) do |sent, notification|
        notification.save!
        next(0) if notification.recipient_id.nil?

        shallow_recipient = notification.recipient(shallow: true)
        next(0) unless conn_res_manager.connected?(shallow_recipient)

        send_via_ws(notification)
        sent + 1
      end
    end

    def send_via_ws(notification)
      recipient = notification.recipient(shallow: true)
      SenderJob.perform_later(recipient, { loco: { notification: notification.compact } })
    end

    def notify_about_xhr_notifications(shallow_recipients)
      fetch_identifiers(shallow_recipients).inject([]) do |uuids, ident|
        Loco::WsConnectionManager.new(ident).connected_uuids.each do |uuid|
          next(uuids) if uuids.include?(uuid)

          SenderJob.perform_later(uuid, loco: { xhr_notifications: true })
          uuids << uuid
        end
      end
    end

    def sync_time_via_ws(notifications)
      sync_time = notifications.last.created_at.iso8601(6)
      notifications.each do |notification|
        recipient = notification.recipient(shallow: true)
        SenderJob.perform_later(recipient, loco: { sync_time: sync_time })
      end
    end

    def notifications_recipients(notifications)
      notifications
        .map { |n| n.recipient(shallow: true) }
        .map { |o| o.instance_of?(Class) ? o.to_s.downcase : nil }
    end

    def fetch_identifiers(shallow_recipients)
      uniq_recipients = shallow_recipients.compact.uniq
      WsConnectedResourcesManager.identifiers.find_all do |str|
        if shallow_recipients.include?(nil)
          true
        else
          uniq_recipients.include?(str.split(':').first)
        end
      end
    end
  end
end
