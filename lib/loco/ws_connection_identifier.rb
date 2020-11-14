# frozen_string_literal: true

module Loco
  module WsConnectionIdentifier
    module_function

    def call(resource)
      case resource
      when String then resource
      when Class then resource.name.downcase
      else "#{resource.class.name.downcase}:#{resource.id}"
      end
    end
  end
end
