module Loco
  class NotificationCenter
    include Emitter

    def received_signal permissions, data
      case data['signal']
      when 'ping'
        return if permissions[:admin].nil?
        user = User.new id: data['user_id']
        emit_to user, signal: 'ping'
      when 'message'
        return if permissions[:user].nil?
        hub = Hub.get "room_#{data['room_id']}"
        return if hub.nil?
        emit_to hub, signal: 'message', message: data['txt'], author: permissions[:user].username
      end
    end
  end
end