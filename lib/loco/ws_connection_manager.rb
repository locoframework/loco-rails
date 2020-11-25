# frozen_string_literal: true

module Loco
  class WsConnectionManager
    EXPIRATION = 60 * 3
    VERIFICATION_STATUS = 'verification'

    def initialize(resource)
      @resource = resource
    end

    def add(uuid)
      WsConnectionStorage.current.add(identifier, uuid)
      WsConnectionStorage.current.add("uuid:#{uuid}", identifier)
      update(uuid)
      check_connections(skip: uuid)
    end

    def del(uuid)
      WsConnectionStorage.current.rem(identifier, uuid)
      WsConnectionStorage.current.rem("uuid:#{uuid}", identifier)
      WsConnectionStorage.current.del(uuid)
      check_connections
    end

    def update(uuid)
      WsConnectionStorage.current.set(uuid, 'ok', ex: EXPIRATION)
    end

    private

    def identifier
      WsConnectionIdentifier.call(@resource)
    end

    def connection_status(uuid)
      WsConnectionStorage.current.get(uuid)
    end

    def check_connections(skip: nil)
      WsConnectionStorage.current.members(identifier).each do |uuid|
        next if uuid == skip
        next if ['ok', VERIFICATION_STATUS].include?(connection_status(uuid))

        WsConnectionStorage.current.set(uuid, VERIFICATION_STATUS)
        SenderJob.perform_later(uuid, loco: { connection_check: true })
        # TODO: trigger a job to delete an unverified uuid
      end
    end
  end
end
