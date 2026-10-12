# frozen_string_literal: true

module Loco
  class NotificationCenterChannel < ApplicationCable::Channel
    def subscribed
      return unless loco_permissions.is_a?(Array)

      @uuid, *signed_in_resources = PermissionsPresenter.signed_in(loco_permissions)
      return unless @uuid.is_a?(String)

      stream_from("loco:notification_center:#{@uuid}")
      broadcast_to(@uuid, loco: { uuid: @uuid })
      signed_in_resources.each { |resource| WsConnectionManager.new(resource).add(@uuid) }
    end

    def unsubscribed
      PermissionsPresenter.signed_in(loco_permissions, except: :uuid).each do |resource|
        WsConnectionManager.new(resource).del(@uuid)
      end
    end

    def receive(payload)
      if payload.dig('loco', 'pong')
        update_connections
        broadcast_to(@uuid, loco: { ping: true })
      end
      return if payload.keys == ['loco']

      indexed_permissions = PermissionsPresenter.indexed(loco_permissions)
      if NotificationCenter.respond_to?(:call)
        NotificationCenter.call(indexed_permissions, payload)
      else
        NotificationCenter.new.received_message(indexed_permissions, payload)
      end
    end

    protected

    def update_connections
      PermissionsPresenter.indexed(loco_permissions, except: :uuid).each_value do |resource|
        WsConnectionManager.new(resource).update(@uuid)
      end
    end
  end
end
