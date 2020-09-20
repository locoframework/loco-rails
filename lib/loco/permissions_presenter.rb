# frozen_string_literal: true

module Loco
  module PermissionsPresenter
    module_function

    def indexed(loco_permissions)
      loco_permissions.compact.index_by do |o|
        o.class.name.downcase.to_sym
      end
    end
  end
end
