# frozen_string_literal: true

module Loco
  class Config
    cattr_accessor(:silence_logger) { false }
    cattr_accessor(:notifications_size) { 100 }
    cattr_accessor(:app_name) { 'loco' }
    cattr_accessor(:redis_instance) { nil }

    def self.configure(opts = {})
      self.silence_logger = opts[:silence_logger] if opts[:silence_logger]
      self.notifications_size = opts[:notifications_size] if opts[:notifications_size]
      self.app_name = opts[:app_name] if opts[:app_name]
      configure_redis opts[:redis_instance]
    ensure
      true
    end

    def self.configure_redis(redis_instance)
      if redis_instance
        self.redis_instance = redis_instance
        return
      end
      return unless defined? Redis

      Redis.current.get 'random_redis_key'
      self.redis_instance = Redis.current
    rescue Redis::CannotConnectError
      self.redis_instance = nil
    end
  end
end
