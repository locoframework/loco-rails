    identified_by :loco_permissions

    def connect
      # loco_permissions should be the same as in application_controller.rb
      # + SecureRandom.uuid is mandatory at 1st position
      self.loco_permissions = [SecureRandom.uuid, current_user, current_admin]
    end

    protected

      def current_admin
        defined?(Admin) && Admin.find_by(id: cookies.signed[:admin_id])
      end

      def current_user
        defined?(User) && User.find_by(id: cookies.signed[:user_id])
      end
