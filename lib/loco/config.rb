# frozen_string_literal: true

module Loco
  class Config
    CONFIGURATION = Struct.new :silence_logger, :notifications_size, :app_name, :redis_instance

    cattr_accessor(:silence_logger) { false }
    cattr_accessor(:notifications_size) { 100 }
    cattr_accessor(:app_name) { 'loco' }
    cattr_accessor(:redis_instance) { nil }

    def self.configure(config)
      self.silence_logger = config.silence_logger if config.silence_logger
      self.notifications_size = config.notifications_size if config.notifications_size
      self.app_name = config.app_name if config.app_name
      self.redis_instance = config.redis_instance
    end
  end
end
