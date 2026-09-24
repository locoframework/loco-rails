# frozen_string_literal: true

class Room
  module Leave
    def self.call(payload, opts)
      room = Room.find(payload[:id])
      user = opts.dig(:ars, :user) || User.find(payload[:user_id])
      FindHub.(room_id: room.id).del_member(user)
      Loco.emit({ event: :member_left, room_id: room.id, member: { id: user.id } }, subject: room, to: [User])
      Result[ok: true, val: { room: }]
    end
  end
end
