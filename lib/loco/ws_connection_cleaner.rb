# frozen_string_literal: true

module Loco
  module WsConnectionCleaner
    module_function

    def call(identifier, uuid)
      return if WsConnectionStorage.current.get(uuid) != WsConnectionChecker::VERIFICATION_STATUS

      WsConnectionManager.new(identifier, identifier: true).del(uuid, skip_checker: true)
    end
  end
end
