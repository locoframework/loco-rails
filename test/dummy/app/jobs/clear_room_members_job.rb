# frozen_string_literal: true

class ClearRoomMembersJob < ApplicationJob
  queue_as :default

  def perform(room_id)
    hub = Loco.get_hub("room_#{room_id}")
    ClearRoomMembers.call(hub)
  end
end
