class ApplicationController < ActionController::Base
  include Loco::Emitter

  protect_from_forgery with: :exception  # For APIs, you may want to use :null_session instead.

  helper_method :current_admin, :current_user

  private

    def current_admin
      return nil if session[:admin_id].nil?
      return @current_admin if @current_admin
      @current_admin = Admin.find session[:admin_id]
    end

    def current_user
      return nil if session[:user_id].nil?
      return @current_user if @current_user
      @current_user = User.find session[:user_id]
    end

    def loco_permissions
      [current_user, current_admin]
    end
end
