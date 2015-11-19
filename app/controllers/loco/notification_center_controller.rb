module Loco
  class NotificationCenterController < ApplicationController
    def index
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