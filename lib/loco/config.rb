module Loco
  class Config
    cattr_accessor(:silence_logger){ false }
    cattr_accessor(:notifications_size){ 100 }
    cattr_accessor(:app_name){ 'loco' }

    def self.configure opts = {}
      self.silence_logger = opts[:silence_logger] if not opts[:silence_logger].nil?
      self.notifications_size = opts[:notifications_size] if opts[:notifications_size]
      self.app_name = opts[:app_name] if opts[:app_name]
    end
  end
end