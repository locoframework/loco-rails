# frozen_string_literal: true

module Loco
  class Hub
    PREFIX = 'loco:hub:'

    attr_reader :raw_members

    class << self
      def get(name)
        hub = WsConnectionStorage.current.get("#{PREFIX}#{name}")
        return nil if hub.blank?

        new(name, JSON.parse(hub))
      end
    end

    def initialize(name, members = [])
      @name = "#{PREFIX}#{name}"
      @raw_members = members.map { |m| serialize(m) }
    end

    def name
      @name.split(PREFIX).last
    end

    def add_member(member)
      serialized = serialize(member)
      return raw_members if raw_members.include?(serialized)

      raw_members << serialized
      save
      raw_members
    end

    def del_member(member)
      serialized = serialize(member)
      return nil unless raw_members.include?(serialized)

      raw_members.delete(serialized)
      save
      serialized
    end

    def destroy
      WsConnectionStorage.current.del(@name)
      true
    end

    def save
      WsConnectionStorage.current.set(@name, raw_members.to_json)
      self
    end

    def include?(resource)
      raw_members.include?(serialize(resource))
    end

    def members
      raw_members.map do |str|
        klass, id = str.split(':')
        klass.classify.constantize.find_by(id: id)
      end
    end

    def connected_uuids
      raw_members.map do |m|
        WsConnectionManager.new(m).connected_uuids
      end.flatten.uniq
    end

    private

    def serialize(member)
      WsConnectionManager.new(member).identifier
    end
  end
end
