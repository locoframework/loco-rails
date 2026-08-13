# frozen_string_literal: true

module Loco
  module PermissionsPresenter
    module_function

    def indexed(loco_permissions, except: nil)
      signed_in(loco_permissions, except:).index_by { |o| o.class.name.underscore.to_sym }
    end

    def signed_in(loco_permissions, except: nil)
      arr = loco_permissions.compact
      except == :uuid ? arr.grep_v(String) : arr
    end
  end
end
