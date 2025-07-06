# frozen_string_literal: true

class HubFinder
  def initialize(room)
    @room = room
  end

  def find
    hub = Loco.get_hub(name)
    if hub
      ClearRoomMembers.call(hub)
      hub
    else
      Loco.add_hub(name)
    end
  end

  private

  def name
    "room_#{@room.id}"
  end
end
