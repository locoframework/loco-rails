# frozen_string_literal: true

module Loco
  class NotificationCenter
    def received_message(permissions, data)
      return unless (res = validate_message(data['type'], permissions, data))

      case data['type']
      when 'PING'
        Loco.emit({ type: 'PING' }, to: res[:user], ws_only: true)
      when 'HEARTBEAT'
        heartbeat(permissions[:user], data['room_id'])
      when 'NEW_MESSAGE'
        new_message(permissions[:user], data, res[:hub])
      end
    end

    private

    def heartbeat(user, room_id)
      hub = FindHub.(room_id:)
      MaintainRoomMembers.rejoin(hub:, user:)
      MaintainRoomMembersJob.set(wait: 5.seconds).perform_later(room_id)
    end

    def new_message(user, data, hub)
      if data['message_type'] == 'persistent' && hub
        Message.create!(room_id: data['room_id'], user:, content: data['txt'])
      end
      Loco.emit({
                  type: 'NEW_MESSAGE',
                  message: data['txt'],
                  author: user.username
                },
                to: hub,
                ws_only: data['message_type'] == 'ephemeral')
    end

    def validate_message(name, permissions, data) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/MethodLength
      case name
      when 'PING'
        return false if permissions[:admin].nil?

        user = User.new(id: data['user_id'])
        { user: }
      when 'HEARTBEAT'
        permissions[:user] ? true : false
      when 'NEW_MESSAGE'
        return false if permissions[:user].nil?
        return false unless (hub = Hub.get("room_#{data['room_id']}"))

        { hub: }
      else
        false
      end
    end
  end
end
