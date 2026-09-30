# frozen_string_literal: true

class Query
  class Room
    RoomWithHub = Struct.new(:room, :hub)

    def initialize(scope)
      @scope = scope
    end

    def all(page:)
      rooms = @scope.paginate(page:, per_page: 10)
      rooms_with_hub = rooms.map { |room| RoomWithHub[room:, hub: FindHub.(room_id: room.id)] }
      { rooms:, rooms_with_hub: }
    end
  end
end
