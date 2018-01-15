# frozen_string_literal: true

module Loco
  class WsConnectionManager
    def initialize resource
      @resource = resource
    end

    def identifier
      return @resource if @resource.is_a?(String)
      "#{@resource.class.name.downcase}:#{@resource.id}"
    end

    def connected? uuid
      connected_uuids.include? uuid
    end

    def connected_uuids
      data.find_all{ |_, v| v.is_a? String }.to_h.keys
    end

    def add uuid
      update uuid
      check_connections
    end

    def del uuid
      save(data.tap{ |h| h.delete uuid })
      check_connections
    end

    def update uuid
      save(data.tap{ |h| h[uuid] = current_time })
    end

    def destroy
      WsConnectionStorage.current.del identifier
    end

    protected

      def data
        serialized_uuids = WsConnectionStorage.current.get identifier
        return {} if serialized_uuids.blank?
        JSON.parse serialized_uuids
      end

      def uuids
        data.keys
      end

      def save hash
        WsConnectionStorage.current.set identifier, hash.to_json
      end

      def check_connections
        hash = data.to_a.map do |arr|
          uuid, val = check_connection arr.first, arr.last
          [uuid, val]
        end.to_h.compact
        save hash
      end

      def check_connection uuid, val
        case val
        when String
          val = check_connection_str uuid, val
        when Hash
          uuid, val = check_connection_hash uuid, val
        end
        [uuid, val]
      end

      def check_connection_str uuid, val
        return val if Time.zone.parse(val) >= 3.minutes.ago
        SenderJob.perform_later uuid, loco: { connection_check: true }
        { 'check' => current_time }
      end

      def check_connection_hash uuid, val
        return [uuid, val] if Time.zone.parse(val['check']) >= 5.seconds.ago
        [nil, nil]
      end

      def current_time
        Time.current.iso8601(6)
      end
  end
end
