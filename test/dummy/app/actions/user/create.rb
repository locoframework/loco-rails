# frozen_string_literal: true

class User
  module Create
    def self.call(payload)
      user = User.new(payload[:user])
      if user.save
        Loco.emit({ event: :created }, subject: user, to: Admin::SupportMember)
        Result[ok: true, val: { user: }]
      else
        Result[ok: false, val: { user: }]
      end
    end
  end
end
