module Loco
  class NotificationCenter
    include Emitter

    def perform permissions, data
      case data['todo']
      when 'ping'
        return if permissions[:admin].nil?
        user = User.new id: data['user_id']
        emit_to user, {action: 'ping'}
      end
    end
  end
end