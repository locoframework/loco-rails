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
        # the same stream as notifications, so every one broadcast before is already delivered:
        # an idle client keeps its sync point fresh and isn't mistaken for one offline past retention
        broadcast_to(@uuid, loco: { ping: true, synced_at: Notification::Presenter.synced_at(Time.current) })
      end
      return if payload.keys == ['loco']

      notify(PermissionsPresenter.indexed(loco_permissions), payload)
    end

    protected

    def notify(permissions, payload)
      if NotificationCenter.respond_to?(:call)
        NotificationCenter.call(permissions, payload)
      else
        DEPRECATOR.warn(
          '`NotificationCenter#received_message` is deprecated. ' \
          'Define `NotificationCenter.call(permissions, payload)` instead.'
        )
        NotificationCenter.new.received_message(permissions, payload)
      end
    end

    def update_connections
      PermissionsPresenter.indexed(loco_permissions, except: :uuid).each_value do |resource|
        WsConnectionManager.new(resource).update(@uuid)
      end
    end
  end
end
