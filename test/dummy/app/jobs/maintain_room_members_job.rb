# frozen_string_literal: true

class MaintainRoomMembersJob < ApplicationJob
  queue_as :default

  def perform(room_id)
    MaintainRoomMembers.clear(room_id)
  end
end
