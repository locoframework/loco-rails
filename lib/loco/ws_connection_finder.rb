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
          storage.scan(match: 'h:*', &block)
        when Class
          storage.scan(match: "h:#{WsConnectionIdentifier.call(resource)}:*", &block)
        else
          storage.scan_hash(WsConnectionIdentifier.call(resource), &block)
        end
      end
    end
  end
end
