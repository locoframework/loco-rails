# frozen_string_literal: true

class User
  class RoomsController < UserController
    before_action :find_room, only: %i[show join leave destroy]
    before_action :find_hub, only: %i[join leave destroy]

    def index
      @rooms = Room.paginate page: params[:page], per_page: 10
      @rooms_with_hub = @rooms.map do |room|
        OpenStruct.new room: room, hub: HubFinder.new(room).find
      end
    end

    def new
      @room = Room.new
    end

    def create
      @room = Room.new params_room
      if @room.save
        emit @room, :created, data: { room: { id: @room.id, name: @room.name } }
        redirect_to user_rooms_path, notice: 'Room has been created'
      else
        render :new
      end
    end

    def show
      render
    end

    def join
      @hub.add_member current_user
      emit @room, :member_joined, data: {
        room_id: @room.id,
        member: {
          id: current_user.id,
          username: current_user.username
        }
      }
      redirect_to user_room_url(id: params[:id])
    end

    def leave
      @hub.del_member current_user
      emit @room, :member_left, data: {
        room_id: @room.id,
        member: { id: current_user.id }
      }
      redirect_to user_rooms_path
    end

    def destroy
      if @hub.raw_members.any?
        redirect_to user_rooms_path, alert: 'Only empty room can be deleted'
        return
      end
      del_hub @hub
      @room.destroy
      emit @room, :destroyed, data: { room_id: @room.id }
      redirect_to user_rooms_path, notice: 'Room has been deleted'
    end

    protected

    def params_room
      params.require(:room).permit :name
    end

    def find_room
      @room = Room.find params[:id]
    end

    def find_hub
      @hub = HubFinder.new(@room).find
    end
  end
end
