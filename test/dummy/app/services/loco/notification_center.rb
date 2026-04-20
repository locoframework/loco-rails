# frozen_string_literal: true

module Loco
  class NotificationCenter
    def received_message(permissions, payload)
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
      MaintainRoomMembers.rejoin(hub:, user:)
      MaintainRoomMembersJob.set(wait: 5.seconds).perform_later(room_id)
    end

    def new_message(user, payload, hub)
      if payload['message_type'] == 'persistent'
        Message.create!(room_id: payload['room_id'], user:, content: payload['txt'])
      end
      Loco.emit({
                  type: 'NEW_MESSAGE',
                  message: payload['txt'],
                  author: user.username
                },
                to: hub,
                ws_only: payload['message_type'] == 'ephemeral')
    end

    def validate_message(name, permissions, payload) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/MethodLength
      case name
      when 'PING'
        return false if permissions[:admin].nil?

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
