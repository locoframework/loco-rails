# frozen_string_literal: true

class Room
  module Destroy
    def self.call(payload)
      room = Room.find(payload[:id])
      hub = FindHub.(room_id: room.id)
      return Result[ok: false, val: { room: }] if hub.raw_members.any?

      Loco.del_hub(hub)
      room.destroy
      Loco.emit({ event: :destroyed, room_id: room.id }, subject: room, to: [User])
      Result[ok: true, val: { room: }]
    end
  end
end
