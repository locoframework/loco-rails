module Loco
  class Notification::Fetcher
    attr_accessor :max_size

    def initialize synced_at:, permissions: [], recipient_token: nil, max_size: nil
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
      notifications.size == max_size ? notifications.last.created_at : Time.current
    end

    private

      def sync_time
        @synced_at.present? ? Time.zone.parse(@synced_at) : Time.current
      end

      def default_scope
        Notification.order("created_at ASC").where("created_at > ?", sync_time)
      end

      # OPTIMIZE: one query
      def notifications
        return @notifications if @notifications
        notifications = notifications_for_all
        notifications += notifications_behind_permissions
        if @recipient_token
          notifications += notifications_behind_token
        end
        @notifications = notifications.sort_by{ |n| n.created_at }[0, max_size]
      end

      def notifications_for_all
        default_scope.where(recipient_class: nil, recipient_id: nil, recipient_token: nil).first max_size
      end

      def notifications_behind_permissions
        notifications = []
        @permissions.each do |permission|
          next if not permission
          klass = permission.class.name
          id = permission.id
          sql = "(recipient_class = ? AND recipient_id = ?) OR (recipient_class = ? AND recipient_id IS NULL)"
          notifications += default_scope.where(sql, klass, id, klass).first max_size
        end
        notifications
      end

      def notifications_behind_token
        default_scope.where(recipient_token: @recipient_token).first max_size
      end
  end
end