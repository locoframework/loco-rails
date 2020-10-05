# frozen_string_literal: true

module Loco
  module WsConnectionFinder
    module_function

    def call(resources)
      storage = WsConnectionStorage.current
      resources.each do |resource|
        if resource.is_a?(Class)
          storage.find(match: "#{resource.name.downcase}:*") { |_, v| yield(v) }
        else
          yield(storage.get("#{resource.class.name.downcase}:#{resource.id}"))
        end
      end
    end
  end
end
