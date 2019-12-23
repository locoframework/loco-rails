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
        fetcher = Notification::Fetcher.new notif_fetcher_args
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
        return [] unless defined? loco_permissions
        return loco_permissions if params[:uuid].blank?

        process_loco_permissions
      end

      def process_loco_permissions
        resources_to_del = []
        resources_to_add = []
        loco_permissions.each do |resource|
          next if resource.nil?

          ws_conn_manager = WsConnectionManager.new resource
          next unless ws_conn_manager.connected?(params[:uuid])

          resources_to_del << resource
          resources_to_add << resource.class
        end
        loco_permissions - resources_to_del + resources_to_add.uniq
      end
  end
end
