# frozen_string_literal: true

class User
  class SessionsController < ApplicationController
    def new
      flash.now[:notice] = 'Your account has been verified. You can sign in now.' if params[:event] == 'confirmed'
      render
    end

    def create
      user = User.find_by(email: params[:email])
      if user && !user.confirmed?
        auth_failed 'Your account is waiting for confirmation.'
      elsif user.nil? || !user.authenticate(params[:password])
        auth_failed
      else
        auth_succeeded user
      end
    end

    def destroy
      cookies.signed[:user_id] = nil
      redirect_to new_user_session_url, notice: 'Successfully signed out.'
    end

    private

    def auth_failed(alert = 'Invalid email or password.')
      redirect_to new_user_session_url, alert: alert
    end

    def auth_succeeded(user)
      cookies.signed[:user_id] = user.id
      redirect_to user_root_url, notice: 'Successfully signed in.'
    end
  end
end
