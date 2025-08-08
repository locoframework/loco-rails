# frozen_string_literal: true

class User
  class MembersController < ApplicationController
    def index
      room = Room.find(params[:room_id])
      @members = FindHub.(room_id: room.id).members
    end
  end
end
