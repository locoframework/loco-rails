# frozen_string_literal: true

module Loco
  class Notification
    class Fetcher
      attr_accessor :max_size

      def initialize(
        synced_at:,
        permissions: [],
        recipient_token: nil,
        max_size: nil
      )
        @synced_at = synced_at
        @permissions = permissions
        @recipient_token = recipient_token
        @notifications = nil
        @max_size = max_size || Loco::Config.notifications_size
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

        def sync_time
          Time.zone.parse @synced_at
        end

        def default_scope
          Notification.order('created_at ASC')
                      .where('created_at > ?', sync_time)
        end

        # OPTIMIZE: one query
        def notifications
          return @notifications if @notifications
          notifications = notifications_for_all
          notifications += notifications_behind_permissions
          notifications += notifications_behind_token if @recipient_token
          @notifications = notifications.sort_by(&:created_at)[0, max_size]
        end

        def notifications_for_all
          default_scope.where(
            recipient_class: nil,
            recipient_id: nil,
            recipient_token: nil
          ).first max_size
        end

        def notifications_behind_permissions
          notifications = []
          @permissions.each do |resource|
            next unless resource
            notifications += notification_for_resource resource
          end
          notifications
        end

        def notifications_behind_token
          default_scope.where(recipient_token: @recipient_token).first max_size
        end

        def notification_for_resource resource
          if resource.instance_of? Class
            sql = 'recipient_class = ? AND recipient_id IS NULL'
            return default_scope.where(sql, resource.to_s).first max_size
          end
          klass = resource.class.name
          cond1 = '(recipient_class = ? AND recipient_id = ?)'
          cond2 = '(recipient_class = ? AND recipient_id IS NULL)'
          sql = "#{cond1} OR #{cond2}"
          default_scope.where(sql, klass, resource.id, klass).first max_size
        end
    end
  end
end
