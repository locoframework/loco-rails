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

    def find(id)
      room = @scope.find(id)
      { room:, messages: room.messages.includes(:user).order(:created_at).last(50) }
    end

    def messages(id, after_id:)
      @scope.find(id).messages.includes(:user).where('messages.id > ?', after_id).order(:id).limit(500)
    end
  end
end
