# frozen_string_literal: true

module Loco
  class NotificationCenterController < ApplicationController
    def index
      if Loco::Config.silence_logger
        logger.silence { fetch_notifications }
      else
        fetch_notifications
      end
    end

    def sync_time
      render json: { sync_time: Time.current.iso8601(6) }
    end

    private

    def fetch_notifications
      if params[:synced_at].blank?
        render json: [[], Time.current.iso8601(6)]
        return
      end
      fetcher = Notification::Fetcher.new(notif_fetcher_args)
      render json: [
        fetcher.formatted_notifications,
        fetcher.next_sync_time.iso8601(6)
      ]
    end

    def notif_fetcher_args
      {
        synced_at: params[:synced_at],
        permissions: permissions,
        recipient_token: params[:token]
      }
    end

    def permissions
      return [] unless defined?(loco_permissions)

      loco_permissions
    end
  end
end
