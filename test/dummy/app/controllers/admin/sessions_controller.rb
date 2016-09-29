class Admin::SessionsController < ApplicationController
  def new
    render
  end

  def create
    admin = Admin.find_by email: params[:email]
    auth_failed && return if admin.nil?
    auth_failed && return if not admin.authenticate params[:password]
    cookies.signed[:admin_id] = admin.id
    redirect_to admin_root_url, notice: 'Successfully signed in.'
  end

  def destroy
    cookies.signed[:admin_id] = nil
    redirect_to new_admin_session_url, notice: 'Successfully signed out.'
  end

  private

    def auth_failed
      redirect_to new_admin_session_url, alert: 'Invalid email or password.'
    end
end