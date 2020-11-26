# frozen_string_literal: true

module Loco
  class CleanerJob < ActiveJob::Base
    queue_as :loco

    def perform(identifier, uuid)
      WsConnectionCleaner.call(identifier, uuid)
    end
  end
end
