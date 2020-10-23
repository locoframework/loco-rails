# frozen_string_literal: true

module Loco
  module WsConnectionIdentifier
    module_function

    def call(resource)
      case resource
      when String then "h:#{resource}"
      when Class then "h:#{resource.name.downcase}"
      else "h:#{resource.class.name.downcase}:#{resource.id}"
      end
    end
  end
end
