module Loco
  class UuidJob < ActiveJob::Base
    queue_as :default

    def perform identifier, uuid, action
      serialized_uuids = Redis.current.get identifier
      case action
      when 'add'
        uuids = serialized_uuids.present? ? Set.new(JSON.parse(serialized_uuids)) : Set.new
        uuids.add uuid
      when 'del'
        return if serialized_uuids.blank?
        uuids = Set.new JSON.parse(serialized_uuids)
        uuids.delete uuid
      end
      Redis.current.set identifier, uuids.to_a.to_json
      #Redis.current.expire identifier, 60
    end
  end
end