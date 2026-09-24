# frozen_string_literal: true

module Admin
  class SupportMember
    module Authenticate
      def self.call(payload)
        admin = SupportMember.find_by(email: payload[:email])
        if admin&.authenticate(payload[:password])
          Result[ok: true, val: { admin: }]
        else
          Result[ok: false, val: {}]
        end
      end
    end
  end
end
