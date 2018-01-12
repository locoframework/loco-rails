# frozen_string_literal: true

module Loco
  class Notification < ActiveRecord::Base
    serialize :data, JSON

    validates :obj_class, presence: true
    validates :event, presence: true

    before_validation :prepare

    class << self
      def table_name_prefix; 'loco_' end
    end

    def obj= val
      if val.instance_of? Class
        self.obj_class = val.to_s
      else
        self.obj_class = val.class.name
        self.obj_id = val.id
        @obj = val
      end
    end

    def obj; @obj end

    def recipient= val
      return nil if val.nil?
      return nil if val == :all
      if val.is_a? String
        self.recipient_token = val
      elsif val.instance_of? Class
        self.recipient_class = val.to_s
      else
        self.recipient_class = val.class.name
        self.recipient_id = val.id
      end
    end

    def recipient opts = {}
      return recipient_token if recipient_token
      return nil if recipient_class.nil? && recipient_id.nil?
      return recipient_class.constantize if recipient_id.nil?
      if opts[:shallow]
        return recipient_class.constantize.new id: recipient_id
      end
      recipient_class.constantize.find recipient_id
    end

    def prepare
      set_event
      set_data
    end

    def compact
      [obj_class, obj_id, event, data]
    end

    private

      def set_event
        return if event.present?
        return if obj.instance_of? Class
        self.event = "creating" if obj.new_record?
        self.event = "created" if obj.created_at.present? && obj.created_at == obj.updated_at
        self.event = "updated" if obj.created_at.present? && obj.created_at != obj.updated_at
      end

      def set_data
        self.data ||= {}
        return if obj.nil?
        self.data.merge!(id: obj.id)
      end
  end
end
