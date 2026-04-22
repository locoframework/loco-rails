# frozen_string_literal: true

module Loco
  class Hub
    PREFIX = 'hub:'

    class << self
      def set(name, members)
        new(name).tap do |hub|
          members.map { |member| hub.add_member(member) }
        end
      end

      def get(name)
        return nil if WsConnectionStorage.current.type("s:#{full_name(name)}") != 'set'

        new(name)
      end

      def full_name(val)
        "#{PREFIX}#{val}"
      end
    end

    attr_reader :name, :full_name

    def initialize(name)
      @name = name
      @full_name = self.class.full_name(name)
    end

    def add_member(member)
      WsConnectionStorage.current.add(@full_name, WsConnectionIdentifier.(member))
    end

    def del_member(member)
      WsConnectionStorage.current.rem(@full_name, WsConnectionIdentifier.(member))
    end

    def include?(member)
      WsConnectionStorage.current.member?(@full_name, WsConnectionIdentifier.(member))
    end

    def destroy
      raw_members.each do |member|
        WsConnectionStorage.current.rem(@full_name, member)
      end
    end

    def raw_members
      WsConnectionStorage.current.members(@full_name)
    end

    def members(shallow: false)
      raw_members.map do |identifier|
        if identifier.include?(':')
          klass, id = identifier.split(':')
          klass = klass.classify.constantize
          shallow ? klass.new(id:) : klass.find_by(id:)
        else
          identifier.classify.constantize
        end
      end
    end
  end
end
