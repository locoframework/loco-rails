# frozen_string_literal: true

module Loco
  class UuidManager
    class << self
      def dispatch(action, uuid, ws_conn_manager)
        case action
        when 'add'
          add(ws_conn_manager, uuid)
        when 'del'
          del(ws_conn_manager, uuid)
        when 'update'
          update(ws_conn_manager, uuid)
        end
      end

      private

      def add(ws_conn_manager, uuid)
        ws_conn_manager.add(uuid)
      end

      def del(ws_conn_manager, uuid)
        ws_conn_manager.del(uuid)
      end

      def update(ws_conn_manager, uuid)
        ws_conn_manager.update(uuid)
      end
    end
  end
end
