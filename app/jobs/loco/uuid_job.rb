# frozen_string_literal: true

module Loco
  class UuidJob < ActiveJob::Base
    queue_as :loco

    def perform(serialized_resource, uuid, action)
      return unless %w[add del update].include?(action)

      resource = Jobs::ResourceSerializer.deserialize(serialized_resource)
      return unless resource

      ws_conn_manager = WsConnectionManager.new(resource)
      return unless ws_conn_manager

      ws_conn_manager.public_send(action, uuid)
    end
  end
end
