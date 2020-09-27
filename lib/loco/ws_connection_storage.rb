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
      @storage = Config.redis_instance
    end

    def get(key)
      storage.get(proper_key(key))
    end

    def set(key, val)
      storage.set(proper_key(key), val)
    end

    def del(key)
      storage.del(proper_key(key))
    end

    private

    def proper_key(key)
      "#{Config.app_name}:#{key}"
    end
  end
end
