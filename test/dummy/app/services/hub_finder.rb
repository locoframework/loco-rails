# frozen_string_literal: true

class HubFinder
  def initialize(room)
    @room = room
  end

  def find
    name = "room_#{@room.id}"
    Loco.get_hub(name) || Loco.add_hub(name)
  end
end
