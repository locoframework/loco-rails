# frozen_string_literal: true

module Loco
  module WsConnectionChecker
    VERIFICATION_STATUS = 'verification'

    module_function

    def call(identifier, skip: nil)
      WsConnectionStorage.current.members(identifier).each do |uuid|
        next if uuid == skip
        next if ['ok', VERIFICATION_STATUS].include?(WsConnectionStorage.current.get(uuid))

        WsConnectionStorage.current.set(uuid, VERIFICATION_STATUS)
        SenderJob.perform_later(uuid, loco: { connection_check: true })
        # TODO: trigger a job to delete an unverified uuid
      end
    end
  end
end
