# frozen_string_literal: true

class Room
  module List
    RoomWithHub = Struct.new(:room, :hub)

    def self.call(payload)
      rooms = Room.paginate(page: payload[:page], per_page: 10)
      rooms_with_hub = rooms.map { |room| RoomWithHub[room:, hub: FindHub.(room_id: room.id)] }
      Result[ok: true, val: { rooms:, rooms_with_hub: }]
    end
  end
end
