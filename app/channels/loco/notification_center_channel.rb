module Loco
  class NotificationCenterChannel < ApplicationCable::Channel
    def subscribed
      return if not loco_permissions.is_a?(Array)
      loco_permissions.each do |permission|
        next if permission.nil?
        stream_from "loco:notification_center:#{permission.class.name.downcase}:#{permission.id}"
      end
    end

    def unsubscribed
    end

    def receive data
      permissions = loco_permissions.compact.map{ |o| [o.class.name.downcase.to_sym, o] }.to_h
      NotificationCenter.new.perform permissions, data
    end
  end
end