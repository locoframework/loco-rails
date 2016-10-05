module Loco
  class SenderJob < ActiveJob::Base
    queue_as :default

    def perform recipient, data
      Sender.new(recipient, data).emit
    end
  end
end