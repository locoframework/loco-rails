# frozen_string_literal: true

module Loco
  class Notification < ApplicationRecord
    def self.table_name_prefix
      'loco_'
    end

    def obj=(val)
      return if val.nil?

      klass, id = case val
                  when Class then [val, nil]
                  when Array then val
                  else [val.class, val.id]
                  end
      self.obj_class = klass.to_s
      self.obj_id = id
    end

    def recipient=(val)
      return if val.nil? || val == :all

      if val.is_a?(String)
        self.recipient_token = val
      elsif val.instance_of?(Class)
        self.recipient_class = val.to_s
      else
        self.recipient_class = val.class.name
        self.recipient_id = val.id
      end
    end

    def recipient(shallow: false)
      if !recipient_token.nil?
        recipient_token
      elsif regular_recipient?
        init_recipient(shallow)
      elsif !recipient_class.nil?
        recipient_class.constantize
      end
    end

    def message
      key, type, payload = wire_fields
      { loco: { idempotency_key: key, created_at: created_at&.iso8601(6) }, type:, payload:, obj_class:, obj_id: }
    end

    private

    # ponytail: rows written before the idempotency_key column keep the key, the
    # type and the payload inside `data` — drop the else branch once they're GC'd
    def wire_fields
      if idempotency_key
        [idempotency_key, event, data || {}]
      else
        stored = data || {}
        payload = stored.fetch('payload') { stored.except('loco') }
        [stored.dig('loco', 'idempotency_key'), event || stored['type'], payload]
      end
    end

    def regular_recipient?
      !recipient_class.nil? && !recipient_id.nil?
    end

    def init_recipient(shallow)
      if shallow
        recipient_class.constantize.new(id: recipient_id)
      else
        recipient_class.constantize.find(recipient_id)
      end
    end
  end
end
