# frozen_string_literal: true

module Loco
  class WsConnectionFinder
    class << self
      def call(resources, &block)
        storage = WsConnectionStorage.instance
        resources = [resources] unless resources.is_a?(Array)
        resources.each do |resource|
          case resource
          when :all then storage.scan(all: true, &block)
          when Hub then call(resource.members(shallow: true), &block)
          when Class
            storage.scan(match: "#{WsConnectionIdentifier.(resource)}:*", &block)
          else
            storage.members(WsConnectionIdentifier.(resource)).each(&block)
          end
        end
      end
    end
  end
end
