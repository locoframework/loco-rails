module Loco
  class Hub
    PREFIX = 'loco:hub:'

    attr_reader :raw_members

    def initialize name, raw_members = []
      @name = "#{PREFIX}#{name}"
      @raw_members = raw_members.map{ |m| serialize m }
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
      return raw_members if raw_members.include? serialized
      raw_members << serialized
      save
      raw_members
    end

    def del_member member
      serialized = serialize member
      return nil if not raw_members.include? serialized
      raw_members.delete serialized
      save
      serialized
    end

    def destroy
      WsConnectionStorage.current.del @name
      true
    end

    def save
      WsConnectionStorage.current.set @name, raw_members.to_json
      self
    end

    def include? resource
      raw_members.include? serialize(resource)
    end

    def members
      raw_members.map do |str|
        klass, id = str.split ':'
        klass.classify.constantize.find_by id: id
      end
    end

    private

      def serialize member
        WsConnectionManager.new(member).identifier
      end
  end
end