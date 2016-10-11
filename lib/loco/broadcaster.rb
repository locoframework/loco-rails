module Loco
  class Broadcaster
    attr_reader :obj, :event, :recipients, :data, :notifications

    def initialize obj, event = nil, opts = {}
      recipient_key = opts[:for] ? :for : :to
      @obj = obj
      @event = event
      @recipients = opts[recipient_key] ? [*opts[recipient_key]] : [nil]
      @data = opts[:data]
      @notifications = []
      @sent_via_ws = 0
      @connected_resources_manager = WsConnectedResourcesManager.new @recipients.compact
    end

    def signals; notifications end

    def prepare
      init_notifications if notifications.empty?
      prepare_notifications
    end

    def emit
      init_notifications if notifications.empty?
      send_notifications
      if notify_about_xhr_notifications?
        notify_about_xhr_notifications
      else
        set_sync_time_via_ws
      end
    end

    private

      def init_notifications
        recipients.each do |recipient|
          @notifications << Notification.new({
            obj: obj,
            event: event,
            recipient: recipient,
            data: data
          })
        end
      end

      def prepare_notifications
        notifications.each do |notification|
          notification.prepare
        end
      end

      def send_notifications
        notifications.each do |notification|
          notification.save!
          next if notification.recipient_id.nil?
          next if not @connected_resources_manager.connected? notification.recipient(shallow: true)
          send_via_ws notification
        end
      end

      def send_via_ws notification
        recipient = notification.recipient shallow: true
        data = {loco: {notification: notification.compact}}
        SenderJob.perform_later recipient, data
        @sent_via_ws += 1
      end

      def notify_about_xhr_notifications?
        @sent_via_ws < notifications.size ? true : false
      end

      def notify_about_xhr_notifications
        uuids, recipients = [], notifications_recipients
        uniq_recipients = recipients.compact.uniq
        Loco::WsConnectedResourcesManager.identifiers.find_all do |str|
          if recipients.include? nil
            true
          else
            uniq_recipients.include? str.split(':').first
          end
        end.each do |identifier|
          Loco::WsConnectionManager.new(identifier).connected_uuids.each do |uuid|
            next if uuids.include? uuid
            uuids << uuid
            SenderJob.perform_later uuid, loco: {xhr_notifications: true}
          end
        end
      end

      def set_sync_time_via_ws
        sync_time = notifications.last.created_at.iso8601(6)
        notifications.each do |notification|
          recipient = notification.recipient shallow: true
          SenderJob.perform_later recipient, loco: {sync_time: sync_time}
        end
      end

      def notifications_recipients
        notifications.map{ |n| n.recipient shallow: true }.map do |o|
          o.instance_of?(Class) ? o.to_s.downcase : nil
        end
      end
  end
end