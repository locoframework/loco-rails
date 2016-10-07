module Loco
  class Broadcaster
    attr_reader :obj, :event, :recipients, :data, :notifications

    def initialize obj, event = nil, opts = {}
      @obj = obj
      @event = event
      @recipients = opts[:for] ? [*opts[:for]] : [nil]
      @data = opts[:data]
      @notifications = []
    end

    def signals; notifications end

    def prepare
      init_notifications if notifications.empty?
      notifications.each do |notification|
        notification.prepare
      end
    end

    def emit
      init_notifications if notifications.empty?
      notifications.each do |notification|
        notification.save!
        next if notification.recipient_id.nil?
        next if WsConnectionManager.new(notification.recipient(shallow: true)).connected_uuids.empty?
        send_via_ws notification
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

      def send_via_ws notification
        data = {loco: {notification: notification.compact}}
        SenderJob.perform_later notification.recipient(shallow: true), data
      end
  end
end