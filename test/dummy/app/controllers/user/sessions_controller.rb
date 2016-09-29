class User::SessionsController < ApplicationController
  def new
    if params[:event] == 'confirmed'
      flash.now[:notice] = 'Your account has been verified. You can sign in now.'
    end
    render
  end

  def create
    user = User.find_by email: params[:email]
    auth_failed && return if user.nil?
    auth_failed('Your account is waiting for confirmation.') && return if not user.confirmed?
    auth_failed && return if not user.authenticate params[:password]
    cookies.signed[:user_id] = user.id
    redirect_to user_root_url, notice: 'Successfully signed in.'
  end

  def destroy
    cookies.signed[:user_id] = nil
    redirect_to new_user_session_url, notice: 'Successfully signed out.'
  end

  private

    def auth_failed alert = 'Invalid email or password.'
      redirect_to new_user_session_url, alert: alert
    end
end