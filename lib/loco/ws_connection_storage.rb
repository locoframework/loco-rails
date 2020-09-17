# frozen_string_literal: true

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

    def get(key)
      case @storage
      when Hash
        storage[proper_key(key)]
      else
        storage.get(proper_key(key))
      end
    end

    def set(key, val)
      case @storage
      when Hash
        storage[proper_key(key)] = val
      else
        storage.set(proper_key(key), val)
      end
    end

    def del(key)
      case @storage
      when Hash
        storage.delete(proper_key(key))
      else
        storage.del(proper_key(key))
      end
    end

    protected

    def proper_key(key)
      "#{Config.app_name}:#{key}"
    end
  end
end
