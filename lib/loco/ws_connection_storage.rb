module Loco
  class WsConnectionStorage
    include Singleton

    class << self
      def current
        if defined? Redis
          return Redis.current
        end
        instance
      end
    end

    def initialize
      @storage = {}
    end

    def get key
      @storage[key]
    end

    def set key, val
      @storage[key] = val
    end

    def del key
      @storage.delete key
    end
  end
end