module Loco
  class Config
    cattr_accessor(:silence_logger){ false }
    cattr_accessor(:notifications_size){ 100 }
    cattr_accessor(:app_name){ 'loco' }
    cattr_accessor(:ws_connection_storage){ 'redis' }

    def self.configure opts = {}
      self.silence_logger = opts[:silence_logger] if not opts[:silence_logger].nil?
      self.notifications_size = opts[:notifications_size] if opts[:notifications_size]
      self.app_name = opts[:app_name] if opts[:app_name]
      begin
        self.ws_connection_storage = if defined?(Redis) && Redis.current.get('version')
          'redis'
        else
          'in_process'
        end
      rescue Redis::CannotConnectError
        self.ws_connection_storage = 'in_process'
      end
      true
    end
  end
end