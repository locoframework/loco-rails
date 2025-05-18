# frozen_string_literal: true

module Loco
  class Notification < ApplicationRecord
    FOR_OBJ_SQL_TMPL = 'recipient_class = ? AND recipient_id = ?'
    FOR_CLASS_SQL_TMPL = 'recipient_class = ? AND recipient_id IS NULL'

    attr_reader :obj

    serialize :data, coder: JSON if ActiveRecord::Base.connection.adapter_name != 'PostgreSQL'

    before_validation do
      set_event
      set_data
    end

    class << self
      def table_name_prefix
        'loco_'
      end
    end

    def obj=(val)
      if val.instance_of? Class
        self.obj_class = val.to_s
      elsif val
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

    def recipient(shallow: false)
      if !recipient_token.nil?
        recipient_token
      elsif regular_recipient?
        init_recipient(shallow)
      elsif !recipient_class.nil?
        recipient_class.constantize
      end
    end

    def compact
      [obj_class, obj_id, event, data]
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

    def set_event
      return if event.present?
      return if obj.instance_of?(Class)
      return if obj.nil?

      self.event = if obj.new_record?
                     'creating'
                   else
                     event_for_persisted_obj
                   end
    end

    def event_for_persisted_obj
      obj.created_at == obj.updated_at ? 'created' : 'updated'
    end

    def set_data
      self.data ||= {}
      return if obj.nil?

      self.data = data.merge(id: obj.id)
    end
  end
end
