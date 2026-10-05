# frozen_string_literal: true

class User
  class SessionsController < ApplicationController
    def new
      flash.now[:notice] = t('flash.account_verified') if params[:event] == 'confirmed'
      render
    end

    def create
      res = perform(action: User::Authenticate, payload: params)
      if res.ok
        cookies.signed[:user_id] = res.val[:user].id
        redirect_to user_root_url, notice: t('flash.signed_in')
      else
        redirect_to new_user_session_url, alert: res.val[:error]
      end
    end

    def destroy
      cookies.signed[:user_id] = nil
      redirect_to new_user_session_url, notice: t('flash.signed_out')
    end
  end
end
