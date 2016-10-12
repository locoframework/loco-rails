module Loco
  class Hub
    PREFIX = 'loco:hub:'

    attr_reader :members

    def initialize name, members = []
      @name = "#{PREFIX}#{name}"
      @members = members.map{ |m| serialize m }
    end

    class << self
      def get name
        hub = WsConnectionStorage.current.get "#{PREFIX}#{name}"
        return nil if hub.blank?
        new name, JSON.parse(hub)
      end
    end

    def name
      @name.split(PREFIX).last
    end

    def add_member member
      serialized = serialize member
      return members if members.include? serialized
      members << serialized
      save
      members
    end

    def del_member member
      serialized = serialize member
      return nil if not members.include? serialized
      members.delete serialized
      save
      serialized
    end

    def destroy
      WsConnectionStorage.current.del @name
      true
    end

    def save
      WsConnectionStorage.current.set @name, members.to_json
      self
    end

    def include? resource
      members.include? serialize(resource)
    end

    private

      def serialize member
        WsConnectionManager.new(member).identifier
      end
  end
end