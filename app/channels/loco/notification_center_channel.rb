# frozen_string_literal: true

module Loco
  class NotificationCenterChannel < ApplicationCable::Channel
    def subscribed
      return unless loco_permissions.is_a?(Array)

      signed_in_resources = PermissionsPresenter.signed_in(loco_permissions)
      stream_for_resources(signed_in_resources)
      return if signed_in_resources.size > 1

      SenderJob.perform_later(@uuid, loco: { start_ajax_polling: true })
    end

    def unsubscribed
      PermissionsPresenter.signed_in(loco_permissions, except: :uuid).each do |resource|
        manage_uuids(resource, 'del')
      end
    end

    def receive(data)
      update_connections if data['loco'] && data['loco']['connection_check']
      indexed_permissions = PermissionsPresenter.indexed(loco_permissions)
      NotificationCenter.new.received_message(indexed_permissions, data)
    end

    protected

    def stream_for_resources(resources)
      resources.each do |resource|
        if resource.is_a?(String)
          @uuid = resource
          stream_for_resource(resource)
          SenderJob.perform_later(@uuid, loco: { uuid: @uuid })
        else
          manage_uuids(resource, 'add')
        end
      end
    end

    def stream_for_resource(resource)
      stream_from "loco:notification_center:#{resource}"
    end

    def update_connections
      PermissionsPresenter.indexed(loco_permissions, except: :uuid).each do |_key, val|
        manage_uuids(val, 'update')
      end
    end

    def manage_uuids(resource, action)
      WsConnectionManager.new(resource).public_send(action, @uuid)
    end
  end
end
