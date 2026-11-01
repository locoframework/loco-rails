# frozen_string_literal: true

class Room
  module Join
    def self.call(payload, opts)
      room = Room.find(payload[:id])
      user = opts.dig(:ars, :user) || User.find(payload[:user_id])
      MaintainRoomMembers.rejoin(hub: FindHub.(room_id: room.id), user:)
      MaintainRoomMembers.schedule_clear(room.id)
      Result[ok: true, val: { room: }]
    end
  end
end
