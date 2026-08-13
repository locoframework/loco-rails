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
          when Hub then search_the_hub(resource, &block)
          when Class
            storage.scan(match: "#{WsConnectionIdentifier.(resource)}:*", &block)
          else
            storage.members(WsConnectionIdentifier.(resource)).each(&block)
          end
        end
      end

      private

      def search_the_hub(hub, &block)
        WsConnectionStorage.instance.members(hub.full_name).map do |identifier|
          WsConnectionStorage.instance.members(identifier).each(&block)
        end
      end
    end
  end
end
