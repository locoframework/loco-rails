# frozen_string_literal: true

module Loco
  class NotificationCenterController < ::ApplicationController
    def index
      logger.silence(Loco::Config.log_level) do
        render json: Notification::Fetch.(synced_at: params[:synced_at],
                                          permissions: (loco_permissions if defined?(loco_permissions)),
                                          recipient_token: params[:token])
      end
    end
  end
end
