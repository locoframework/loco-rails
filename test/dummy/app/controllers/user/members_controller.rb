# frozen_string_literal: true

class User
  class MembersController < ApplicationController
    def index
      @members = perform(query: Room::Members, payload: { room_id: params[:room_id] }).val[:members]
    end
  end
end
