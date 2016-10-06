module Loco
  class NotificationCenterChannel < ApplicationCable::Channel
    def subscribed
      return if not loco_permissions.is_a?(Array)
      loco_permissions.each do |resource|
        next if resource.nil?
        if resource.is_a? String
          @uuid = resource
          stream_from "loco:notification_center:#{@uuid}"
          SenderJob.perform_later @uuid, loco: {uuid: @uuid}
        else
          UuidJob.perform_later resource, @uuid, 'add'
          identifier = WsConnectionManager.new(resource).identifier
          stream_from "loco:notification_center:#{identifier}"
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
      permissions = loco_permissions.compact.map{ |o| [o.class.name.downcase.to_sym, o] }.to_h
      NotificationCenter.new.received_signal permissions, data
    end
  end
end