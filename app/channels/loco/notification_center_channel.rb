# frozen_string_literal: true

module Loco
  class NotificationCenterChannel < ApplicationCable::Channel
    def subscribed
      return unless loco_permissions.is_a?(Array)

      stream_for_resources
      return if PermissionsPresenter.signed_in(loco_permissions).size > 1

      SenderJob.perform_later @uuid, loco: { start_ajax_polling: true }
    end

    def unsubscribed
      loco_permissions.each do |resource|
        next if resource.nil? || resource.is_a?(String)

        UuidJob.perform_later(Jobs::ResourceSerializer.serialize(resource), @uuid, 'del')
      end
    end

    def receive(data)
      update_connections if data['loco'] && data['loco']['connection_check']
      indexed_permissions = PermissionsPresenter.indexed(loco_permissions)
      NotificationCenter.new.received_message indexed_permissions, data
    end

    protected

    def stream_for_resources
      PermissionsPresenter.signed_in(loco_permissions).each do |resource|
        if resource.is_a? String
          @uuid = resource
          stream_for_resource resource
          SenderJob.perform_later @uuid, loco: { uuid: @uuid }
        else
          UuidJob.perform_later(Jobs::ResourceSerializer.serialize(resource), @uuid, 'add')
          stream_for_resource resource
        end
      end
    end

    def stream_for_resource(resource)
      identifier = WsConnectionManager.new(resource).identifier
      stream_from "loco:notification_center:#{identifier}"
    end

    def update_connections
      PermissionsPresenter.indexed(loco_permissions).each do |key, val|
        next if key == :string

        UuidJob.perform_later(Jobs::ResourceSerializer.serialize(val), @uuid, 'update')
      end
    end
  end
end
