module Loco
  class WsConnectionStorage
    include Singleton

    attr_reader :storage

    class << self
      def current
        instance
      end
    end

    def initialize
      @storage = Config.redis_instance || {}
    end

    def get key
      storage[proper_key(key)]
    end

    def set key, val
      storage[proper_key(key)] = val
    end

    def del key
      if storage.is_a? Hash
        storage.delete proper_key(key)
      else
        storage.del proper_key(key)
      end
    end

    protected

      def proper_key key
        "#{Config.app_name}:#{key}"
      end
  end
end
