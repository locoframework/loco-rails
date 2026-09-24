# frozen_string_literal: true

class User
  module Authenticate
    def self.call(payload)
      user = User.find_by(email: payload[:email])
      if user && !user.confirmed?
        Result[ok: false, val: { error: 'Your account is waiting for confirmation.' }]
      elsif user.nil? || !user.authenticate(payload[:password])
        Result[ok: false, val: { error: 'Invalid email or password.' }]
      else
        Result[ok: true, val: { user: }]
      end
    end
  end
end
