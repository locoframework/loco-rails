# frozen_string_literal: true

module Loco
  class NotificationCenter
    include Emitter

    def received_message(permissions, data)
      return unless (res = validate_message(data['type'], permissions, data))

      case data['type']
      when 'PING'
        emit_to res[:user], type: 'PING'
      when 'NEW_MESSAGE'
        emit_to res[:hub],
                type: 'NEW_MESSAGE',
                message: data['txt'],
                author: permissions[:user].username
      end
    end

    protected

    def validate_message(name, permissions, data)
      case name
      when 'PING'
        return false if permissions[:admin].nil?

        user = User.new id: data['user_id']
        { user: user }
      when 'NEW_MESSAGE'
        return false if permissions[:user].nil?
        return false unless (hub = find_room(data['room_id']))

        { hub: hub }
      else
        false
      end
    end

    def find_room(id)
      Hub.get "room_#{id}"
    end
  end
end
