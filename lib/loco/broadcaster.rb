module Loco
  class Broadcaster
    attr_reader :obj, :event, :recipients, :data, :notifications

    def initialize obj, event = nil, opts = {}
      @obj = obj
      @event = event
      @recipients = opts[:for] ? [*opts[:for]] : [nil]
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
      return if not notify_about_xhr_notifications?
      notify_about_xhr_notifications
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
        recipient = notification.recipient(shallow: true)
        data = {loco: {notification: notification.compact}}
        SenderJob.perform_later recipient, data
        @sent_via_ws += 1
      end

      def notify_about_xhr_notifications?
        @sent_via_ws < notifications.size ? true : false
      end

      def notify_about_xhr_notifications
        Loco::WsConnectedResourcesManager.identifiers.each do |identifier|
          SenderJob.perform_later identifier, loco: {xhr_notifications: true}
        end
      end
  end
end