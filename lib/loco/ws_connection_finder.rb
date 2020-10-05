# frozen_string_literal: true

module Loco
  module WsConnectionFinder
    module_function

    def call(resources, &block)
      storage = WsConnectionStorage.current
      resources.each do |resource|
        if resource.is_a?(Class)
          storage.scan(match: "#{resource.name.downcase}:*", &block)
        else
          storage.scan_hash("#{resource.class.name.downcase}:#{resource.id}", &block)
        end
      end
    end
  end
end
