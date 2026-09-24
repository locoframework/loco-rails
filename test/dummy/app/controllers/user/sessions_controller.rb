# frozen_string_literal: true

class User
  class SessionsController < ApplicationController
    def new
      flash.now[:notice] = t('flash.account_verified') if params[:event] == 'confirmed'
      render
    end

    def create
      res = perform(action: User::Authenticate, payload: { email: params[:email], password: params[:password] })
      res.ok ? auth_succeeded(res.val[:user]) : auth_failed(res.val[:error])
    end

    def destroy
      cookies.signed[:user_id] = nil
      redirect_to new_user_session_url, notice: t('flash.signed_out')
    end

    private

    def auth_failed(alert)
      redirect_to new_user_session_url, alert:
    end

    def auth_succeeded(user)
      cookies.signed[:user_id] = user.id
      redirect_to user_root_url, notice: t('flash.signed_in')
    end
  end
end
