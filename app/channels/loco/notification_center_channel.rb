# frozen_string_literal: true

module Loco
  class NotificationCenterChannel < ApplicationCable::Channel
    def subscribed
      return unless loco_permissions.is_a?(Array)
      stream_for_resources
      return if loco_permissions.compact.size > 1
      SenderJob.perform_later @uuid, loco: { start_ajax_polling: true }
    end

    def unsubscribed
      loco_permissions.each do |resource|
        next if resource.nil? || resource.is_a?(String)
        UuidJob.perform_later serialize_resource(resource), @uuid, 'del'
      end
    end

    def receive data
      update_connections if data['loco'] && data['loco']['connection_check']
      NotificationCenter.new.received_signal permissions, data
    end

    protected

      def stream_for_resources
        loco_permissions.compact.each do |resource|
          if resource.is_a? String
            @uuid = resource
            stream_for_resource resource
            SenderJob.perform_later @uuid, loco: { uuid: @uuid }
          else
            UuidJob.perform_later serialize_resource(resource), @uuid, 'add'
            stream_for_resource resource
          end
        end
      end

      def stream_for_resource resource
        identifier = WsConnectionManager.new(resource).identifier
        stream_from "loco:notification_center:#{identifier}"
      end

      def permissions
        loco_permissions.compact.map do |o|
          [o.class.name.downcase.to_sym, o]
        end.to_h
      end

      def update_connections
        permissions.each do |key, val|
          next if key == :string
          UuidJob.perform_later serialize_resource(val), @uuid, 'update'
        end
      end

      def serialize_resource resource
        { 'class' => resource.class.name, 'id' => resource.id }
      end
  end
end
