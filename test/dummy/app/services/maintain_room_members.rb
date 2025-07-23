# frozen_string_literal: true

class MaintainRoomMembers
  class << self
    def rejoin(hub:, user:)
      room_id = hub.name.split(':').last.split('_').last
      key = redis_key(room_id, user.id)
      APP_REDIS.set(key, Time.current, ex: 4)
      return if hub.include?(user)

      hub.add_member(user)
      emit_member_joined(room_id:, user:)
    end

    def clear(room_id)
      hub = Loco.get_hub("room_#{room_id}")
      return unless hub

      hub.members(shallow: true).each do |member|
        next if APP_REDIS.get(redis_key(room_id, member.id))

        hub.del_member(member)
        # TODO: refactor Room.new(id: room_id)
        Loco.emit(Room.new(id: room_id), :member_left, payload: {
                    room_id:,
                    member: { id: member.id }
                  }, to: [User])
      end
    end

    private

    def redis_key(room_id, user_id)
      "room_##{room_id}_user##{user_id}"
    end

    def emit_member_joined(room_id:, user:)
      Loco.emit({
                  event: :member_joined,
                  room_id:,
                  member: {
                    id: user.id,
                    username: user.username
                  }
                }, subject: Room.new(id: room_id), to: [User])
    end
  end
end
