module Loco
  class NotificationCenterController < ApplicationController
    def index
      if Loco::Config.silence_logger
        logger.silence{ fetch_notifications }
      else
        fetch_notifications
      end
    end

    private

      def fetch_notifications
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
        ws_permissions = []
        loco_permissions.each do |permission|
          arr = Redis.current.get identifier_for_permission(permission)
          next if arr.blank?
          if arr.include? params[:uuid]
            ws_permissions << permission
          end
        end
        loco_permissions - ws_permissions
      end

      # TODO: duplication
      def identifier_for_permission permission
        "#{permission.class.name.downcase}:#{permission.id}"
      end
  end
end