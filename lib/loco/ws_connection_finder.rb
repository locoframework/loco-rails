# frozen_string_literal: true

module Loco
  module WsConnectionFinder
    module_function

    def call(resources, &block)
      storage = WsConnectionStorage.current
      resources = [resources] unless resources.is_a?(Array)
      resources.each do |resource|
        case resource
        when :all
          storage.scan(all: true, &block)
        when Class
          storage.scan(match: "#{WsConnectionIdentifier.call(resource)}:*", &block)
        else
          storage.members(WsConnectionIdentifier.call(resource)).each(&block)
        end
      end
    end
  end
end
