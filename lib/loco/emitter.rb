module Loco
  module Emitter
    def emit obj, event = nil, opts = {}
      recipients = opts[:for] ? [*opts[:for]] : [nil]
      recipients.each do |recipient|
        Notification.new(event: event, data: opts[:data]).tap do |n|
          n.obj = obj
          n.recipient = recipient
        end.save!
      end
    end
  end
end