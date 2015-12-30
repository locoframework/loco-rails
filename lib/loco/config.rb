module Loco
  class Config
    cattr_accessor :silence_logger do
      false
    end

    def self.configure opts = {}
      self.silence_logger = opts[:silence_logger] if not opts[:silence_logger].nil?
    end
  end
end