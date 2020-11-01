# frozen_string_literal: true

module Loco
  class NotificationCenterChannel < ApplicationCable::Channel
    def subscribed
      return unless loco_permissions.is_a?(Array)

      signed_in_resources = PermissionsPresenter.signed_in(loco_permissions)
      @uuid = signed_in_resources[0]
      return unless @uuid.is_a?(String)

      stream_from("loco:notification_center:#{@uuid}")
      SenderJob.perform_later(@uuid, loco: { uuid: @uuid })

      return if signed_in_resources[1..].empty?

      signed_in_resources[1..].each { |resource| manage_uuids(resource, 'add') }
      # SenderJob.perform_later(@uuid, loco: { start_ajax_polling: true })
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
