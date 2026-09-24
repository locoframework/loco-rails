# frozen_string_literal: true

class User
  class MembersController < ApplicationController
    def index
      @members = FindHub.(room_id: Room.find(params[:room_id]).id).members
    end
  end
end
