module Loco
  class Config
    cattr_accessor(:silence_logger){ false }
    cattr_accessor(:notifications_size){ 100 }
    cattr_accessor(:app_name){ 'loco' }
    cattr_accessor(:redis_instance){ nil }

    def self.configure opts = {}
      self.silence_logger = opts[:silence_logger] if not opts[:silence_logger].nil?
      self.notifications_size = opts[:notifications_size] if opts[:notifications_size]
      self.app_name = opts[:app_name] if opts[:app_name]
      if opts[:redis_instance]
        self.redis_instance = opts[:redis_instance]
        return
      end
      return if not defined?(Redis)
      Redis.current.get 'random_redis_key'
      self.redis_instance = Redis.current
    rescue Redis::CannotConnectError
      self.redis_instance = nil
    ensure
      return true
    end
  end
end
