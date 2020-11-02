# frozen_string_literal: true

module Loco
  class WsConnectionManager
    def initialize(resource)
      @resource = resource
    end

    def connected?(uuid)
      !WsConnectionStorage.current.get(identifier, uuid).nil?
    end

    def add(uuid)
      update(uuid)
      check_connections
    end

    def del(uuid)
      WsConnectionStorage.current.del(identifier, uuid)
      check_connections
    end

    def update(uuid)
      WsConnectionStorage.current.set(identifier, uuid => current_time)
    end

    def destroy
      WsConnectionStorage.current.del(identifier)
    end

    private

    def identifier
      WsConnectionIdentifier.call(@resource)
    end

    def current_time
      Time.current.iso8601(6)
    end

    def save(hash)
      WsConnectionStorage.current.set(identifier, hash)
    end

    def check_connections
      uuids_to_check = []
      WsConnectionStorage.current.scan_hash(identifier) do |uuid, time|
        next if time == ''

        uuids_to_check << uuid if Time.zone.parse(time) < 3.minutes.ago
      end
      uuids_to_check.each do |uuid|
        WsConnectionStorage.current.set(identifier, uuid => '')
        SenderJob.perform_later(uuid, loco: { connection_check: true })
      end
    end
  end
end
