# frozen_string_literal: true

module Loco
  module PermissionsPresenter
    module_function

    def indexed(loco_permissions, opts = {})
      h = signed_in(loco_permissions).index_by do |o|
        o.class.name.downcase.to_sym
      end
      if opts[:except] == :uuid
        h.reject { |k, _| k == :string }
      else
        h
      end
    end

    def signed_in(loco_permissions, opts = {})
      arr = loco_permissions.compact
      if opts[:except] == :uuid
        arr.reject { |e| e.is_a?(String) }
      else
        arr
      end
    end
  end
end
