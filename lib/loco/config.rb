module Loco
  class Config
    cattr_accessor(:silence_logger){ false }
    cattr_accessor(:notifications_size){ 100 }

    def self.configure opts = {}
      self.silence_logger = opts[:silence_logger] if not opts[:silence_logger].nil?
      self.notifications_size = opts[:notifications_size] if opts[:notifications_size]
    end
  end
end