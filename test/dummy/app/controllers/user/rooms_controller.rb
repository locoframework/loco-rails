# frozen_string_literal: true

class User
  class RoomsController < UserController
    RoomWithHub = Struct.new(:room, :hub)

    before_action :find_room, only: %i[show join leave destroy]
    before_action :find_hub, only: %i[join leave destroy]

    def index
      @rooms = Room.paginate page: params[:page], per_page: 10
      @rooms_with_hub = @rooms.map do |room|
        RoomWithHub.new(room, HubFinder.new(room).find)
      end
    end

    def new
      @room = Room.new
    end

    def create
      @room = Room.new params_room
      if @room.save
        Loco.emit({ event: :created, room: { id: @room.id, name: @room.name } }, subject: @room, to: [User])
        redirect_to user_rooms_path, notice: 'Room has been created'
      else
        render :new
      end
    end

    def show
      @messages = @room.messages.includes(:user).order(created_at: :asc).last(50)
    end

    def join
      @hub.add_member current_user
      Loco.emit({
                  event: :member_joined,
                  room_id: @room.id,
                  member: {
                    id: current_user.id,
                    username: current_user.username
                  }
                }, subject: @room, to: [User])
      redirect_to user_room_url(@room)
    end

    def leave
      @hub.del_member current_user
      Loco.emit(@room, :member_left, payload: {
                  room_id: @room.id,
                  member: { id: current_user.id }
                }, to: [User])
      redirect_to user_rooms_path
    end

    def destroy
      if @hub.raw_members.any?
        redirect_to user_rooms_path, alert: 'Only empty room can be deleted'
        return
      end
      del_hub @hub
      @room.destroy
      Loco.emit(@room, :destroyed, payload: { room_id: @room.id }, to: [User])
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
