class ClearRoomMembers
  class << self
    def call(hub)
      room_id = hub.name.split(':').last.split('_').last
      hub.members(shallow: true).each do |member|
        next if APP_REDIS.get(redis_key(room_id, member.id))

        hub.del_member(member)
        # TODO: move to background job (?) to auto emit member_left event
        # TODO: refactor Room.new(id: room_id)
        Loco.emit(Room.new(id: room_id), :member_left, payload: {
                    room_id:,
                    member: { id: member.id }
                  }, to: [User])
      end
    end

    def redis_key(room_id, user_id)
      "room_##{room_id}_user##{user_id}"
    end
  end
end
