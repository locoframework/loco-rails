# frozen_string_literal: true

module Loco
  class BroadcastJob < ActiveJob::Base
    queue_as :loco

    def perform(recipient, payload)
      Broadcast.new(recipient).(payload)
    end
  end
end
