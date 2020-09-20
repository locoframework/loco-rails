# frozen_string_literal: true

module Loco
  module PermissionsPresenter
    module_function

    def indexed(loco_permissions)
      signed_in(loco_permissions).index_by do |o|
        o.class.name.downcase.to_sym
      end
    end

    def signed_in(loco_permissions)
      loco_permissions.compact
    end
  end
end
