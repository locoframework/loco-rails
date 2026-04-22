# frozen_string_literal: true

module Loco
  module WsConnectionIdentifier
    def self.call(resource)
      case resource
      when String then resource
      when Class then resource.name.underscore
      else "#{resource.class.name.underscore}:#{resource.id}"
      end
    end
  end
end
