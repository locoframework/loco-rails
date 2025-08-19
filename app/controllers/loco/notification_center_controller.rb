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

    # TODO: delete in the next release
    def sync_time
      ActiveSupport::Deprecation.warn(
        'Loco::NotificationCenterController#sync_time is deprecated and will be removed in the next release.',
        caller_locations(1)
      )
      render json: { sync_time: Time.current.iso8601(6) }
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
