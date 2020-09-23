# frozen_string_literal: true

module Loco
  class UuidJob < ActiveJob::Base
    queue_as :loco

    def perform(serialized_resource, uuid, action)
      resource = Jobs::ResourceSerializer.deserialize(serialized_resource)
      return unless resource

      ws_conn_manager = WsConnectionManager.new(resource)
      return unless ws_conn_manager

      UuidManager.dispatch(action, uuid, ws_conn_manager)
    end
  end
end
