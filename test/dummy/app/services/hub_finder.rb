# frozen_string_literal: true

class HubFinder
  def initialize(room)
    @room = room
  end

  def find
    Loco.get_hub(name) || Loco.add_hub(name)
  end

  private

  def name
    "room_#{@room.id}"
  end
end
