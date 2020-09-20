# frozen_string_literal: true

module Loco
  class UuidJob < ActiveJob::Base
    queue_as :loco

    def perform(serialized_resource, uuid, action)
      ws_conn_manager = init_ws_conn_manager(serialized_resource)
      return unless ws_conn_manager

      case action
      when 'add'
        add(ws_conn_manager, uuid)
      when 'del'
        del(ws_conn_manager, uuid)
      when 'update'
        update(ws_conn_manager, uuid)
      end
    end

    protected

    def add(ws_conn_manager, uuid)
      ws_conn_manager.add(uuid)
      WsConnectedResourcesManager.add(ws_conn_manager.identifier)
    end

    def del(ws_conn_manager, uuid)
      ws_conn_manager.del(uuid)
      return if ws_conn_manager.connected_uuids.any?

      WsConnectedResourcesManager.del(ws_conn_manager.identifier)
    end

    def update(ws_conn_manager, uuid)
      ws_conn_manager.update(uuid)
      WsConnectedResourcesManager.add(ws_conn_manager.identifier)
    end

    def init_ws_conn_manager(serialized_resource)
      resource = Jobs::ResourceSerializer.deserialize(serialized_resource)
      return unless resource

      WsConnectionManager.new(resource)
    end
  end
end
