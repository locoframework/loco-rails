# frozen_string_literal: true

module Loco
  class WsConnectionManager
    EXPIRATION = 60 * 3

    def initialize(resource)
      @resource = resource
    end

    def add(uuid)
      WsConnectionStorage.current.add(identifier, uuid)
      WsConnectionStorage.current.add("uuid:#{uuid}", identifier)
      update(uuid)
      WsConnectionChecker.call(identifier, skip: uuid)
    end

    def del(uuid)
      WsConnectionStorage.current.rem(identifier, uuid)
      WsConnectionStorage.current.rem("uuid:#{uuid}", identifier)
      WsConnectionStorage.current.del(uuid)
      WsConnectionChecker.call(identifier)
    end

    def update(uuid)
      WsConnectionStorage.current.set(uuid, 'ok', ex: EXPIRATION)
    end

    private

    def identifier
      WsConnectionIdentifier.call(@resource)
    end
  end
end
