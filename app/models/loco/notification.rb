module Loco
  class Notification < ActiveRecord::Base
    serialize :data, JSON

    validates :obj_class, presence: true
    validates :event, presence: true

    before_validation :set_event, :set_data

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
