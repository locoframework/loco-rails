module Loco
  class NotificationCenterController < ApplicationController
    def index
      if Loco::Config.silence_logger
        logger.silence{ fetch_notifications }
      else
        fetch_notifications
      end
    end

    def sync_time
      render json: {sync_time: Time.current.iso8601(6)}
    end

    private

      def fetch_notifications
        if params[:synced_at].blank?
          render json: [[], Time.current.iso8601(6)]
          return
        end
        opts = {
          synced_at: params[:synced_at],
          permissions: permissions,
          recipient_token: params[:token]
        }
        fetcher = Notification::Fetcher.new opts
        render json: [fetcher.formatted_notifications, fetcher.next_sync_time.iso8601(6)]
      end

      def permissions
        return [] if not defined? loco_permissions
        return loco_permissions if params[:uuid].blank?
        resources_to_del = []
        resources_to_add = []
        loco_permissions.each do |resource|
          next if resource.nil?
          next if not WsConnectionManager.new(resource).connected?(params[:uuid])
          resources_to_del << resource
          resources_to_add << resource.class
        end
        loco_permissions - resources_to_del + resources_to_add.uniq
      end
  end
end