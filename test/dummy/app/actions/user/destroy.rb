# frozen_string_literal: true

class User
  module Destroy
    def self.call(payload)
      user = User.find(payload[:id])
      Result[ok: user.destroy.present?, val: { user: }]
    end
  end
end
