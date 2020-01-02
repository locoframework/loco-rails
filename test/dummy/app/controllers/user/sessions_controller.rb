# frozen_string_literal: true

class User
  class SessionsController < ApplicationController
    def new
      if params[:event] == 'confirmed'
        flash.now[:notice] = 'Your account has been verified. You can sign in now.'
      end
      render
    end

    def create
      if (user = User.find_by email: params[:email]).nil?
        auth_failed
      elsif !user.confirmed?
        auth_failed user, 'Your account is waiting for confirmation.'
      elsif !user.authenticate(params[:password])
        auth_failed user
      else
        auth_succeeded user
      end
    end

    def destroy
      cookies.signed[:user_id] = nil
      redirect_to new_user_session_url, notice: 'Successfully signed out.'
    end

    private

    def auth_failed(user = nil, alert = 'Invalid email or password.')
      Ephemeron.used user
      redirect_to new_user_session_url, alert: alert
    end

    def auth_succeeded(user)
      Ephemeron.used user
      cookies.signed[:user_id] = user.id
      redirect_to user_root_url, notice: 'Successfully signed in.'
    end
  end
end
