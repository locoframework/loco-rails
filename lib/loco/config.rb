# frozen_string_literal: true

module Loco
  class Config
    CONFIGURATION = Struct.new :log_level, :notifications_size, :app_name, :redis_instance

    cattr_accessor(:log_level) { :info }
    cattr_accessor(:notifications_size) { 100 }
    cattr_accessor(:app_name) { "loco_#{Rails.env}" }
    cattr_accessor(:redis_instance) { nil }

    def self.configure(config)
      self.log_level = config.log_level if config.log_level
      self.notifications_size = config.notifications_size if config.notifications_size
      self.app_name = config.app_name if config.app_name
      self.redis_instance = config.redis_instance
    end
  end
end
