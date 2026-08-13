# frozen_string_literal: true

module Loco
  class NotificationCenterController < ::ApplicationController
    def index
      logger.silence(Loco::Config.log_level) { fetch_notifications }
    end

    private

    def fetch_notifications
      synced_at = params[:synced_at] || Time.current.iso8601(6)
      fetcher = Notification::Fetcher.new({ synced_at:,
                                            permissions:,
                                            recipient_token: params[:token] })
      render json: [fetcher.formatted_notifications, fetcher.next_sync_time.iso8601(6)]
    end

    def permissions
      return [] unless defined?(loco_permissions)

      loco_permissions
    end
  end
end
