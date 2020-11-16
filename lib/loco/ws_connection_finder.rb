# frozen_string_literal: true

module Loco
  class WsConnectionFinder
    class << self
      def call(resources, &block)
        storage = WsConnectionStorage.current
        resources = [resources] unless resources.is_a?(Array)
        resources.each do |resource|
          case resource
          when :all then storage.scan(all: true, &block)
          when Hub then search_the_hub(resource, &block)
          when Class
            storage.scan(match: "#{WsConnectionIdentifier.call(resource)}:*", &block)
          else
            storage.members(WsConnectionIdentifier.call(resource)).each(&block)
          end
        end
      end

      private

      def search_the_hub(resource, &block)
        WsConnectionStorage.current.members(resource.full_name).map do |serialized|
          WsConnectionStorage.current.members(serialized).each(&block)
        end
      end
    end
  end
end
