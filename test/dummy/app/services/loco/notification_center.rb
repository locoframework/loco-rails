# frozen_string_literal: true

module Loco
  class NotificationCenter
    include Emitter

    def received_signal(permissions, data)
      return unless (res = validate_signal(data['signal'], permissions, data))

      case data['signal']
      when 'ping'
        emit_to res[:user], signal: 'ping'
      when 'message'
        emit_to res[:hub],
                signal: 'message',
                message: data['txt'],
                author: permissions[:user].username
      end
    end

    protected

      def validate_signal(name, permissions, data = {})
        case name
        when 'ping'
          return false if permissions[:admin].nil?

          user = User.new id: data['user_id']
          { user: user }
        when 'message'
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
