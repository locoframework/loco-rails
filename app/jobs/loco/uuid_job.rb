module Loco
  class UuidJob < ActiveJob::Base
    queue_as :default

    def perform resource, uuid, action
      ws_conn_manager = WsConnectionManager.new resource
      case action
      when 'add' then ws_conn_manager.add uuid
      when 'del' then ws_conn_manager.del uuid
      when 'update' then ws_conn_manager.update uuid
      end
    end
  end
end