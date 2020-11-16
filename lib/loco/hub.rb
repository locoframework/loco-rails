# frozen_string_literal: true

module Loco
  class Hub
    PREFIX = 'hub:'

    class << self
      def set(name, members)
        new(name, members)
      end

      def get(name)
        return nil if WsConnectionStorage.current.type("s:#{full_name(name)}") != 'set'

        new(name)
      end

      def full_name(val)
        "#{PREFIX}#{val}"
      end
    end

    def initialize(name, members = [])
      @name = self.class.full_name(name)
      members.map { |member| add_member(member) }
    end

    def name
      full_name.split(PREFIX).last
    end

    def full_name
      @name
    end

    def add_member(member)
      WsConnectionStorage.current.add(@name, WsConnectionIdentifier.call(member))
    end

    def del_member(member)
      WsConnectionStorage.current.rem(@name, WsConnectionIdentifier.call(member))
    end

    def destroy
      WsConnectionStorage.current.members(@name).each do |member|
        WsConnectionStorage.current.rem(@name, member)
      end
    end

    def include?(resource)
      WsConnectionStorage.current.member?(@name, WsConnectionIdentifier.call(resource))
    end

    def raw_members
      WsConnectionStorage.current.members(@name)
    end

    def members
      raw_members.map do |serialized|
        klass, id = serialized.split(':')
        klass.classify.constantize.find_by(id: id)
      end
    end
  end
end
