    include Loco::Permissions::Connection

    def connect
      reject_unauthorized_connection unless current_user || current_admin
    end

    def current_admin
      defined?(Admin) && Admin.find_by(id: cookies.signed[:admin_id])
    end

    def current_user
      defined?(User) && User.find_by(id: cookies.signed[:user_id])
    end
