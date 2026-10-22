# frozen_string_literal: true

module Loco
  class Notification < ApplicationRecord
    def self.table_name_prefix
      'loco_'
    end

    # index: index_loco_notifications_on_idempotency_key_and_recipient_class
    scope :queued, lambda { |idempotency_key:, recipient_class:|
      where(idempotency_key:, recipient_class:, recipient_id: nil, recipient_token: nil)
    }

    scope :updated_after, ->(time) { where('updated_at > ?', time) }

    scope :to_all, -> { where(recipient_class: nil, recipient_id: nil, recipient_token: nil) }

    scope :to_resource, lambda { |resource|
      if resource.instance_of?(Class)
        where(recipient_class: resource.to_s, recipient_id: nil)
      else
        where(recipient_class: resource.class.name, recipient_id: [resource.id, nil])
      end
    }

    scope :to_token, ->(token) { where(recipient_token: token) }

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

    private

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
