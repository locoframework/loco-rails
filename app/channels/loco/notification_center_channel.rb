module Loco
  class NotificationCenterChannel < ApplicationCable::Channel
    def subscribed
      return if not loco_permissions.is_a?(Array)
      loco_permissions.each do |permission|
        next if permission.nil?
        if permission.is_a? String
          @uuid = permission
          stream_from "loco:notification_center:#{@uuid}"
          SenderJob.perform_later @uuid, loco: {uuid: @uuid}
        else
          add_uuid_for permission
          stream_from "loco:notification_center:#{identifier_for_permission(permission)}"
        end
      end
    end

    def unsubscribed
      loco_permissions.each do |permission|
        next if permission.nil? || permission.is_a?(String)
        del_uuid_for permission
      end
    end

    def receive data
      permissions = loco_permissions.compact.map{ |o| [o.class.name.downcase.to_sym, o] }.to_h
      NotificationCenter.new.received_signal permissions, data
    end

    protected

      def identifier_for_permission permission
        "#{permission.class.name.downcase}:#{permission.id}"
      end

      def add_uuid_for permission
        UuidJob.perform_later identifier_for_permission(permission), @uuid, 'add'
      end

      def del_uuid_for permission
        UuidJob.perform_later identifier_for_permission(permission), @uuid, 'del'
      end
  end
end