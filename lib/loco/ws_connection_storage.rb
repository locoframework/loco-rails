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

    def get(key, hkey = nil)
      if !hkey.nil?
        storage.hget(proper_key(key), hkey)
      else
        storage.get(proper_key(key))
      end
    end

    def set(key, val)
      if val.is_a?(Hash)
        storage.hset(proper_key(key), val)
      else
        storage.set(proper_key(key), val)
      end
    end

    def del(key)
      storage.del(proper_key(key))
    end

    def find(match:, &block)
      storage.scan_each(match: "#{proper_key('')}#{match}").each do |key|
        storage.hscan_each(key, &block)
      end
    end

    private

    def proper_key(key)
      "#{Config.app_name}:#{key}"
    end
  end
end
