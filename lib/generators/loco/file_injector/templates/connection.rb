    identified_by :loco_permissions

    def connect
      # should be the same as in application_controller.rb
      self.loco_permissions = [current_user, current_admin]
    end

    protected

      def current_admin
        defined?(Admin) && Admin.find_by(id: cookies.signed[:admin_id])
      end

      def current_user
        defined?(User) && User.find_by(id: cookies.signed[:user_id])
      end
