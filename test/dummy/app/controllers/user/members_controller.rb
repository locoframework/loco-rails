# frozen_string_literal: true

class User
  class MembersController < ApplicationController
    before_action :find_room

    def index
      @members = HubFinder.new(@room).find.members
    end

    protected

      def find_room
        @room = Room.find params[:room_id]
      end
  end
end
