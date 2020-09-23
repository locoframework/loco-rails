# frozen_string_literal: true

module Loco
  class Notification < ApplicationRecord
    attr_reader :obj

    serialize :data, JSON

    validates :obj_class, presence: true
    validates :event, presence: true

    before_validation :prepare

    class << self
      def table_name_prefix
        'loco_'
      end
    end

    def obj=(val)
      if val.instance_of? Class
        self.obj_class = val.to_s
      else
        self.obj_class = val.class.name
        self.obj_id = val.id
        @obj = val
      end
    end

    def recipient=(val)
      return if val.nil?
      return if val == :all

      if val.is_a?(String)
        self.recipient_token = val
      elsif val.instance_of?(Class)
        self.recipient_class = val.to_s
      else
        self.recipient_class = val.class.name
        self.recipient_id = val.id
      end
    end

    def recipient(opts = {})
      return recipient_token if recipient_token
      return unless regular_recipient?
      return class_recipient unless recipient_id

      obj_recipient(opts[:shallow])
    end

    def prepare
      set_event
      set_data
    end

    def compact
      [obj_class, obj_id, event, data]
    end

    private

    def regular_recipient?
      recipient_class && recipient_id
    end

    def class_recipient
      recipient_class.constantize
    end

    def obj_recipient(shallow = false)
      if shallow
        recipient_class.constantize.new(id: recipient_id)
      else
        recipient_class.constantize.find(recipient_id)
      end
    end

    def set_event
      return if event.present?
      return if obj.instance_of? Class

      if obj.new_record?
        self.event = 'creating'
      else
        set_event_for_persisted_obj
      end
    end

    def set_event_for_persisted_obj
      self.event = obj.created_at == obj.updated_at ? 'created' : 'updated'
    end

    def set_data
      self.data ||= {}
      return if obj.nil?

      self.data.merge!(id: obj.id)
    end
  end
end
