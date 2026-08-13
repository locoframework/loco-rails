# frozen_string_literal: true

module Loco
  class WsConnectionStorage
    include Singleton

    attr_reader :storage

    def initialize
      @storage = Config.redis_instance
    end

    def type(key)
      storage.type(proper_key(key))
    end

    def get(key)
      storage.get(proper_key("k:#{key}"))
    end

    def set(key, val, opts = {})
      storage.set(proper_key("k:#{key}"), val, ex: opts[:ex])
    end

    def del(key)
      storage.del(proper_key("k:#{key}"))
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

    def del_set(key)
      storage.del(proper_key("s:#{key}"))
    end

    private

    def proper_key(key)
      "#{Config.app_name}:#{key}"
    end
  end
end
