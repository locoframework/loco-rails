# frozen_string_literal: true

module Loco
  class NotificationCenterController < ::ApplicationController
    def index
      if valid_sync_params?
        logger.silence(Loco::Config.log_level) do
          render json: Notification::Fetch.(synced_at: params[:synced_at],
                                            permissions: (loco_permissions if defined?(loco_permissions)),
                                            recipient_token: params[:token])
        end
      else
        head :bad_request
      end
    end

    private

    # both params reach Time.zone.parse and a token lookup, so an array/hash, an out-of-range date
    # ("2026") or a NUL byte would raise a 500; an unparseable string ("null") still means "no sync point"
    def valid_sync_params?
      synced_at, token = params.values_at(:synced_at, :token)
      scalars = [synced_at, token].all? { _1.nil? || (_1.is_a?(String) && _1.exclude?("\0")) }
      Time.zone.parse(synced_at.to_s) if scalars
      scalars
    rescue ArgumentError
      false
    end
  end
end
