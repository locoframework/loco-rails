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
        storage.hget(proper_key("h:#{key}"), hkey)
      else
        storage.get(proper_key("k:#{key}"))
      end
    end

    def set(key, val, opts = {})
      if val.is_a?(Hash)
        storage.hset(proper_key("h:#{key}"), val)
      else
        storage.set(proper_key("k:#{key}"), val, ex: opts[:ex])
      end
    end

    def del(key, hkey = nil)
      if !hkey.nil?
        storage.hdel(proper_key("h:#{key}"), hkey)
      else
        storage.del(proper_key("k:#{key}"))
      end
    end

    def scan(match: nil, all: false, &block)
      match = 'uuid:*' if all
      storage.scan_each(match: "#{proper_key('s:')}#{match}").each do |key|
        if all
          yield(key.split('uuid:').last)
        else
          storage.smembers(key).each(&block)
        end
      end
    end

    def scan_hash(key, &block)
      storage.hscan_each(proper_key("h:#{key}"), &block)
    end

    def hlen(key)
      storage.hlen(proper_key("h:#{key}"))
    end

    def add(key, val)
      storage.sadd(proper_key("s:#{key}"), val)
    end

    def members(key)
      storage.smembers(proper_key("s:#{key}"))
    end

    def member?(key, val)
      storage.sismember(proper_key("s:#{key}"), val)
    end

    def rem(key, val)
      storage.srem(proper_key("s:#{key}"), val)
    end

    private

    def proper_key(key)
      "#{Config.app_name}:#{key}"
    end
  end
end
