# frozen_string_literal: true

class User
  class MessagesController < UserController
    def index
      @messages = Query.new(current_user).rooms.messages(params.expect(:room_id), after_id: params[:after_id].to_i)
    end
  end
end
