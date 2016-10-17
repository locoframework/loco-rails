module Loco
  class WsConnectionStorage
    include Singleton

    class << self
      def current
        instance
      end
    end

    def initialize
      @storage = Config.ws_connection_storage == 'redis' ? nil : {}
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

      def storage
        @storage || Redis.current
      end

      def proper_key key
        "#{Config.app_name}:#{key}"
      end
  end
end