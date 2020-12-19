# frozen_string_literal: true

module Loco
  module WsConnectionChecker
    module_function

    # TODO: is skip needed?
    def call(identifier, skip: nil)
      WsConnectionStorage.current.members(identifier).each do |uuid|
        next if uuid == skip
        next if WsConnectionStorage.current.get(uuid) == 'ok'

        WsConnectionManager.new(identifier, identifier: true).del(uuid, skip_checker: true)
      end
    end
  end
end
