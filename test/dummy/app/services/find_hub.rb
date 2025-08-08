# frozen_string_literal: true

class FindHub
  def self.call(room_id:)
    name = "room_#{room_id}"
    Loco.get_hub(name) || Loco.add_hub(name)
  end
end
