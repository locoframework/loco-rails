# frozen_string_literal: true

module Loco
  class Notification
    class Fetcher
      attr_reader :max_size

      def initialize(opts)
        @synced_at = opts[:synced_at]
        @permissions = (opts[:permissions] || []).compact
        @recipient_token = opts[:recipient_token]
        @notifications = nil
        @max_size = opts[:max_size] || Loco::Config.notifications_size
      end

      def formatted_notifications
        notifications.map(&:compact)
      end

      def next_sync_time
        if notifications.size == max_size
          notifications.last.created_at
        else
          Time.current
        end
      end

      private

      # a client without a sync point yet (loco-js sends `synced_at=null` on its
      # first check) starts from now — it gets its sync point back in this response
      def sync_time
        Time.zone.parse(@synced_at.to_s) || Time.current
      end

      def default_scope
        Notification.order(:created_at)
                    .where('created_at > ?', sync_time)
      end

      def notifications
        @notifications ||= scopes.reduce(:or).first(max_size)
      end

      def scopes
        scopes = [default_scope.where(recipient_class: nil, recipient_id: nil, recipient_token: nil)]
        scopes += @permissions.map { |resource| scope_for_resource(resource) }
        scopes << default_scope.where(recipient_token: @recipient_token) if @recipient_token
        scopes
      end

      def scope_for_resource(resource)
        return default_scope.where(recipient_class: resource.to_s, recipient_id: nil) if resource.instance_of?(Class)

        default_scope.where(recipient_class: resource.class.name, recipient_id: [resource.id, nil])
      end
    end
  end
end
