# frozen_string_literal: true

module Loco
  class Notification < ApplicationRecord
    FOR_OBJ_SQL_TMPL = 'recipient_class = ? AND recipient_id = ?'
    FOR_CLASS_SQL_TMPL = 'recipient_class = ? AND recipient_id IS NULL'

    def self.table_name_prefix
      'loco_'
    end

    attr_reader :obj

    before_validation do
      self.data = (data || {}).merge(id: obj.id) if obj
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
  end
end
