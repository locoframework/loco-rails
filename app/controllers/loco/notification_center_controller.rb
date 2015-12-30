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
          permissions: defined?(loco_permissions) ? loco_permissions : [],
          recipient_token: params[:token]
        }
        fetcher = Notification::Fetcher.new opts
        render json: [fetcher.formatted_notifications, fetcher.next_sync_time.iso8601(6)]
      end
  end
end