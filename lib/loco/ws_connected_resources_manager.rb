# frozen_string_literal: true

module Loco
  class WsConnectedResourcesManager
    def initialize resources
      @resources = resources
      @connected_resources = nil
    end

    class << self
      def identifiers
        val = WsConnectionStorage.current.get key
        return [] if val.blank?
        JSON.parse val
      end

      def add identifier
        ids = identifiers
        return if ids.include? identifier
        ids << identifier
        WsConnectionStorage.current.set key, ids.to_json
      end

      def del identifier
        ids = identifiers
        return if not ids.include? identifier
        ids.delete identifier
        WsConnectionStorage.current.set key, ids.to_json
      end

      def key; "loco:conn_ids" end
    end

    def connected_resources
      return @connected_resources if @connected_resources
      @resources.each do |resource|
        next if WsConnectionManager.new(resource).connected_uuids.empty?
        add resource
      end
      @connected_resources || []
    end

    def connected? resource
      connected_resources.map do |resource|
        WsConnectionManager.new(resource).identifier
      end.include? WsConnectionManager.new(resource).identifier
    end

    private

      def add resource
        @connected_resources ||= []
        @connected_resources << resource
        @connected_resources.uniq!
      end
  end
end