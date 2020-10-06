# frozen_string_literal: true

module Loco
  module WsConnectionFinder
    module_function

    def call(resources, &block)
      storage = WsConnectionStorage.current
      resources.each do |resource|
        if resource.is_a?(Class)
          storage.scan(match: "#{WsConnectionIdentifier.call(resource)}:*", &block)
        else
          storage.scan_hash(WsConnectionIdentifier.call(resource), &block)
        end
      end
    end
  end
end
