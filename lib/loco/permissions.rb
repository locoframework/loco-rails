# frozen_string_literal: true

module Loco
  module Permissions
    module Controller
      def loco_permissions
        Loco::Config.resources.call(self)
      end
    end

    module Connection
      extend ActiveSupport::Concern

      included do
        identified_by :loco_permissions
        prepend ConnectWrapper
      end

      module ConnectWrapper
        def connect
          self.loco_permissions = [SecureRandom.uuid, *Loco::Config.resources.call(self)]
          super
        end
      end
    end
  end
end
