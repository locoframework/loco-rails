# frozen_string_literal: true

module Loco
  class SenderJob < ActiveJob::Base
    queue_as :loco

    def perform(recipient, payload)
      Sender.(recipient, payload)
    end
  end
end
