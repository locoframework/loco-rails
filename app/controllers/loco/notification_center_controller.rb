module Loco
  class NotificationCenterController < ApplicationController
    def index
      next_sync_time = notifications.size == max_size ? notifications.last.created_at : Time.current
      render json: [formatted_notifications, next_sync_time.iso8601(6)]
    end


    private

      def max_size; 10 end

      def sync_time
        if params[:synced_at].present?
          Time.zone.parse params[:synced_at]
        else
          Time.current
        end
      end

      def notifications
        return @notifications if @notifications
        @notifications = Notification.order("created_at ASC").where("created_at > ?", sync_time).
          first max_size
      end

      def formatted_notifications
        notifications.map{ |n| [n.obj_class, n.obj_id, n.event, n.data] }
      end
  end
end