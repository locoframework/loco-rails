# frozen_string_literal: true

module Loco
  class Sender
    def initialize recipient, data = {}
      @recipients = [*recipient]
      @data = data
    end

    def emit
      uuids.each do |uuid|
        NotificationCenterChannel.broadcast_to uuid, @data
      end
    end

    private

      def uuids
        @recipients.map do |r|
          if r.is_a? String
            r
          elsif r.is_a? Hub
            r.raw_members.map{ |m| WsConnectionManager.new(m).connected_uuids }.flatten.uniq
          else
            WsConnectionManager.new(r).connected_uuids
          end
        end.flatten.uniq
      end
  end
end