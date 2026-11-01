# frozen_string_literal: true

class MaintainRoomMembers
  HEARTBEAT_TTL = Rails.env.test? ? 1 : 10 # survives ~3 missed heartbeats (sent every 3s)

  class << self
    def rejoin(hub:, user:)
      room_id = hub.name.split(':').last.split('_').last.to_i
      key = redis_key(room_id, user.id)
      APP_REDIS.set(key, Time.current, ex: HEARTBEAT_TTL)
      return if hub.include?(user)

      hub.add_member(user)
      emit_member_joined(room_id:, user:)
    end

    # after the key of the heartbeat that scheduled it expires - so a sender's last heartbeat can remove them,
    # even when nobody else in the room is heartbeating
    def schedule_clear(room_id)
      MaintainRoomMembersJob.set(wait: (HEARTBEAT_TTL + 1).seconds).perform_later(room_id)
    end

    def clear(room_id)
      hub = Loco.get_hub("room_#{room_id}")
      return unless hub

      hub.members(shallow: true).each do |member|
        next if APP_REDIS.get(redis_key(room_id, member.id))

        hub.del_member(member)
        Loco.emit({
                    event: :member_left,
                    room_id:,
                    member: { id: member.id }
                  }, subject: [Room, room_id], to: [User])
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
                }, subject: [Room, room_id], to: [User])
    end
  end
end
