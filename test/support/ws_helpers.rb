# frozen_string_literal: true

module WsHelpers
  def create_connection(resource, uuid = SecureRandom.uuid)
    ws_conn_mgr = Loco::WsConnectionManager.new(resource)
    Loco::UuidManager.dispatch('add', uuid, ws_conn_mgr)
  end
end
