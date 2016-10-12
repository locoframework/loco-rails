class User::RoomsController < UserController
  before_action :find_room, only: [:show, :join, :leave]
  before_action :find_hub, only: [:join, :leave]

  def index
    @rooms = Room.paginate page: params[:page], per_page: 10
    @rooms_with_hub = @rooms.map{ |room| OpenStruct.new room: room, hub: find_hub(room) }
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new params_room
    if @room.save
      redirect_to user_rooms_path, notice: "Room has been created"
    else
      render :new
    end
  end

  def show
    render
  end

  def join
    @hub.add_member current_user
    redirect_to user_room_url(id: params[:id])
  end

  def leave
    @hub.del_member current_user
    redirect_to user_rooms_path
  end

  protected

    def params_room
      params.require(:room).permit :name
    end

    def find_room
      @room = Room.find params[:id]
    end

    def find_hub room = nil
      room_id = room ? room.id : @room.id
      name = "room_#{room_id}"
      hub = get_hub(name) || add_hub(name)
      return hub if room
      @hub = hub
    end
end