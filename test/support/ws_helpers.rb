# frozen_string_literal: true

module WsHelpers
  def create_connection(resource, uuid = SecureRandom.uuid)
    Loco::WsConnectionManager.new(resource).add(uuid)
  end
end
