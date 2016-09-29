module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :loco_permissions

    def connect
      self.loco_permissions = [current_user, current_admin]
      logger.add_tags 'AC', loco_permissions.map{ |e| e.try(:id) || '-' }
    end

    protected

      def current_admin
        Admin.find_by id: cookies.signed[:admin_id]
      end

      def current_user
        User.find_by id: cookies.signed[:user_id]
      end
  end
end
