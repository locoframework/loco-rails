module Loco
  class NotificationCenterChannel < ApplicationCable::Channel
    def subscribed
      return if not loco_permissions.is_a?(Array)
      loco_permissions.each do |resource|
        next if resource.nil?
        if resource.is_a? String
          @uuid = resource
          stream_for_resource resource
          SenderJob.perform_later @uuid, loco: {uuid: @uuid}
        else
          UuidJob.perform_later resource, @uuid, 'add'
          stream_for_resource resource
        end
      end
    end

    def unsubscribed
      loco_permissions.each do |resource|
        next if resource.nil? || resource.is_a?(String)
        UuidJob.perform_later resource, @uuid, 'del'
      end
    end

    def receive data
      if data['loco']
        if data['loco']['connection_check']
          update_connections
        end
      end
      NotificationCenter.new.received_signal permissions, data
    end

    protected

      def stream_for_resource resource
        identifier = WsConnectionManager.new(resource).identifier
        stream_from "loco:notification_center:#{identifier}"
      end

      def permissions
        loco_permissions.compact.map{ |o| [o.class.name.downcase.to_sym, o] }.to_h
      end

      def update_connections
        permissions.each do |key, val|
          next if key == :string
          UuidJob.perform_later val, @uuid, 'update'
        end
      end
  end
end