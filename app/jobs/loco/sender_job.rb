# frozen_string_literal: true

module Loco
  class SenderJob < ActiveJob::Base
    queue_as :loco

    def perform(recipient, data)
      Sender.(recipient, data)
    end
  end
end
