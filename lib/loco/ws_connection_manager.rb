# frozen_string_literal: true

module Loco
  class WsConnectionManager
    EXPIRATION = 60 * 3

    def initialize(resource)
      @resource = resource
    end

    def add(uuid)
      WsConnectionStorage.instance.add(identifier, uuid)
      WsConnectionStorage.instance.add("uuid:#{uuid}", identifier)
      update(uuid)
      drop_stale_connections(skip: uuid)
    end

    def del(uuid, skip_checker: false)
      WsConnectionStorage.instance.rem(identifier, uuid)
      WsConnectionStorage.instance.rem("uuid:#{uuid}", identifier)
      WsConnectionStorage.instance.del(uuid)
      drop_stale_connections unless skip_checker
    end

    def update(uuid)
      WsConnectionStorage.instance.set(uuid, 'ok', ex: EXPIRATION)
    end

    private

    # a connection is alive as long as its uuid key hasn't expired
    def drop_stale_connections(skip: nil)
      WsConnectionStorage.instance.members(identifier).each do |uuid|
        next if uuid == skip
        next if WsConnectionStorage.instance.get(uuid) == 'ok'

        del(uuid, skip_checker: true)
      end
    end

    def identifier
      @identifier ||= WsConnectionIdentifier.(@resource)
    end
  end
end
