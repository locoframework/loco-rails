# frozen_string_literal: true

module Loco
  class NotificationCenterChannel < ApplicationCable::Channel
    def subscribed
      return unless loco_permissions.is_a?(Array)

      @uuid, *signed_in_resources = PermissionsPresenter.signed_in(loco_permissions)
      return unless @uuid.is_a?(String)

      stream_from("loco:notification_center:#{@uuid}")
      SenderJob.perform_later(@uuid, loco: { uuid: @uuid })

      return if signed_in_resources.empty?

      signed_in_resources.each { |resource| WsConnectionManager.new(resource).add(@uuid) }
      # SenderJob.perform_later(@uuid, loco: { start_ajax_polling: true })
    end

    def unsubscribed
      PermissionsPresenter.signed_in(loco_permissions, except: :uuid).each do |resource|
        WsConnectionManager.new(resource).del(@uuid)
      end
    end

    def receive(data)
      update_connections if data.dig('loco', 'connection_check')
      indexed_permissions = PermissionsPresenter.indexed(loco_permissions)
      NotificationCenter.new.received_message(indexed_permissions, data)
    end

    protected

    def update_connections
      PermissionsPresenter.indexed(loco_permissions, except: :uuid).each do |_, resource|
        WsConnectionManager.new(resource).update(@uuid)
      end
    end
  end
end
