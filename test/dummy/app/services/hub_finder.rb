# frozen_string_literal: true

class HubFinder
  include Loco::Emitter

  def initialize(room)
    @room = room
  end

  def find
    get_hub(name) || add_hub(name)
  end

  private

    def name
      "room_#{@room.id}"
    end
end
