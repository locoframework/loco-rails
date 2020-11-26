# frozen_string_literal: true

module Loco
  class CleanerJob < ActiveJob::Base
    queue_as :loco

    def perform(uuid)
      WsConnectionCleaner.call(uuid)
    end
  end
end
