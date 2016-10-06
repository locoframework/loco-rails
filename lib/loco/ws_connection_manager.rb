module Loco
  class WsConnectionManager
    def initialize resource
      @resource = resource
    end

    def identifier
      "#{@resource.class.name.downcase}:#{@resource.id}"
    end

    def connected? uuid
      uuids.include? uuid
    end

    def add uuid
      save uuids.add(uuid)
    end

    def del uuid
      save uuids.delete(uuid)
    end

    protected

      def uuids
        serialized_uuids = Redis.current.get identifier
        return Set.new if serialized_uuids.blank?
        Set.new JSON.parse(serialized_uuids)
      end

      def save set
        Redis.current.set identifier, set.to_a.to_json
        #Redis.current.expire identifier, 60
      end
  end
end