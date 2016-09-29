class ApplicationController < ActionController::Base
  include Loco::Emitter

  protect_from_forgery with: :exception  # For APIs, you may want to use :null_session instead.

  helper_method :current_admin, :current_user

  private

    def current_admin
      return nil if cookies.signed[:admin_id].nil?
      @current_admin ||= Admin.find_by id: cookies.signed[:admin_id]
    end

    def current_user
      return nil if cookies.signed[:user_id].nil?
      @current_user ||= User.find_by id: cookies.signed[:user_id]
    end

    def loco_permissions
      [current_user, current_admin]
    end
end
