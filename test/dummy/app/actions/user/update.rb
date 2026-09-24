# frozen_string_literal: true

class User
  module Update
    def self.call(payload)
      user = User.find(payload[:id])
      if user.update(payload[:user])
        Loco.emit({ event: :confirmed }, subject: user, to: [user.token, Admin::SupportMember]) if user.confirmed?
        Result[ok: true, val: { user: }]
      else
        Result[ok: false, val: { user: }]
      end
    end
  end
end
