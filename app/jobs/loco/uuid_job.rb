# frozen_string_literal: true

module Loco
  class UuidJob < ActiveJob::Base
    queue_as :loco

    def perform resource, uuid, action
      ws_conn_manager = WsConnectionManager.new resource
      case action
      when 'add'
        ws_conn_manager.add uuid
        WsConnectedResourcesManager.add ws_conn_manager.identifier
      when 'del'
        ws_conn_manager.del uuid
        return if ws_conn_manager.connected_uuids.any?
        WsConnectedResourcesManager.del ws_conn_manager.identifier
      when 'update'
        ws_conn_manager.update uuid
        WsConnectedResourcesManager.add ws_conn_manager.identifier
      end
    end
  end
end
