# frozen_string_literal: true

module Loco
  class Notification
    class Restamp
      class << self
        def call(recipient, payload)
          idempotency_key = payload.dig(:loco, :idempotency_key)
          idempotency_key ? restamp(recipient, idempotency_key, payload) : payload
        end

        private

        def restamp(recipient, idempotency_key, payload)
          updated_at = Time.current
          recipient_class = recipient.is_a?(Hash) ? recipient['class'] : nil
          # rubocop:disable-next Rails/SkipsModelValidations -- no primary key, so no per-record update
          Notification.queued(idempotency_key:, recipient_class:).update_all(updated_at:)
          payload.deep_merge(loco: { synced_at: Presenter.synced_at(updated_at) })
        end
      end
    end
  end
end
