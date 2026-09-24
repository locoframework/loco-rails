# frozen_string_literal: true

class User
  module StartConfirmation
    def self.call(payload)
      user = User.find(payload[:id])
      Loco.emit({ event: :confirming }, subject: user, to: user.token) unless user.confirmed?
      Result[ok: true, val: { user: }]
    end
  end
end
