# frozen_string_literal: true

module Loco
  class NotificationCenter
    class << self
      def call(permissions, payload)
        return unless (res = validate_message(payload['type'], permissions, payload))

        case payload['type']
        when 'PING'
          Loco.emit({ type: 'PING' }, to: res[:user], ws_only: true)
        when 'HEARTBEAT'
          heartbeat(permissions[:user], payload['room_id'])
        when 'NEW_MESSAGE'
          new_message(permissions[:user], payload, res[:hub])
        end
      end

      private

      def heartbeat(user, room_id)
        hub = FindHub.(room_id:)
        member = hub.include?(user)
        MaintainRoomMembers.rejoin(hub:, user:)
        Loco.emit({ type: 'ROOM_REJOINED', room_id: }, to: user, ws_only: true) unless member
        MaintainRoomMembers.schedule_clear(room_id)
      end

      def new_message(user, payload, hub)
        if payload['message_type'] == 'persistent'
          message = Message.create!(room_id: payload['room_id'], user:, content: payload['txt'])
        end
        Loco.emit({
                    type: 'NEW_MESSAGE',
                    id: message&.id,
                    message: payload['txt'],
                    author: user.username
                  },
                  to: hub,
                  ws_only: payload['message_type'] == 'ephemeral')
      end

      def validate_message(name, permissions, payload) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/MethodLength
        case name
        when 'PING'
          return false if permissions[:'admin/support_member'].nil?

          user = User.new(id: payload['user_id'])
          { user: }
        when 'HEARTBEAT'
          permissions[:user] ? true : false
        when 'NEW_MESSAGE'
          return false if permissions[:user].nil?
          return false unless (hub = Loco.get_hub("room_#{payload['room_id']}"))

          { hub: }
        else
          false
        end
      end
    end
  end
end
