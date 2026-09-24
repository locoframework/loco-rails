# frozen_string_literal: true

class Room
  module Create
    def self.call(payload)
      room = Room.new(payload[:room])
      if room.save
        Loco.emit({ event: :created, room: { id: room.id, name: room.name } }, subject: room, to: [User])
        Result[ok: true, val: { room: }]
      else
        Result[ok: false, val: { room: }]
      end
    end
  end
end
