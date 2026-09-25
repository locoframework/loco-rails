# frozen_string_literal: true

class User
  class RoomsController < UserController
    def index
      res = Query.new(current_user).rooms.all(page: params[:page])
      @rooms, @rooms_with_hub = res.values_at(:rooms, :rooms_with_hub)
    end

    def show
      @room = Room.find(params[:id])
      @messages = @room.messages.includes(:user).order(created_at: :asc).last(50)
    end

    def new
      @room = Room.new
    end

    def create
      res = perform(action: Room::Create, payload: { room: params_room })
      return redirect_to user_rooms_path, notice: t('flash.room_created') if res.ok

      @room = res.val[:room]
      render :new, status: :unprocessable_content
    end

    def join
      res = perform(action: Room::Join, payload: { id: params[:id] }, opts: user_opts)
      redirect_to user_room_url(res.val[:room])
    end

    def leave
      perform(action: Room::Leave, payload: { id: params[:id] }, opts: user_opts)
      redirect_to user_rooms_path
    end

    def destroy
      res = perform(action: Room::Destroy, payload: { id: params[:id] })
      if res.ok
        redirect_to user_rooms_path, notice: t('flash.room_deleted')
      else
        redirect_to user_rooms_path, alert: t('flash.room_not_empty')
      end
    end

    private

    def params_room
      params.expect room: [:name]
    end
  end
end
