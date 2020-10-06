# frozen_string_literal: true

module Loco
  class UuidManager
    class << self
      def dispatch(action, uuid, ws_conn_manager)
        return unless %w[add del update].include?(action)

        ws_conn_manager.public_send(action, uuid)
      end
    end
  end
end
