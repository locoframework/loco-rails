# frozen_string_literal: true

module Loco
  class WsConnectionManager
    EXPIRATION = 60 * 3

    def initialize(resource, opts = {})
      if opts[:identifier]
        @identifier = resource
      else
        @resource = resource
      end
    end

    def add(uuid)
      WsConnectionStorage.current.add(identifier, uuid)
      WsConnectionStorage.current.add("uuid:#{uuid}", identifier)
      update(uuid)
      WsConnectionChecker.call(identifier, skip: uuid)
    end

    def del(uuid, skip_checker: false)
      WsConnectionStorage.current.rem(identifier, uuid)
      WsConnectionStorage.current.rem("uuid:#{uuid}", identifier)
      WsConnectionStorage.current.del(uuid)
      WsConnectionChecker.call(identifier) unless skip_checker
    end

    def update(uuid)
      WsConnectionStorage.current.set(uuid, 'ok', ex: EXPIRATION)
    end

    private

    def identifier
      @identifier ||= WsConnectionIdentifier.call(@resource)
    end
  end
end
