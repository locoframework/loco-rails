# frozen_string_literal: true

module Admin
  class SessionsController < ApplicationController
    def new
      render
    end

    def create
      res = perform(action: Admin::SupportMember::Authenticate,
                    payload: { email: params[:email], password: params[:password] })
      res.ok ? authenticated(res.val[:admin]) : auth_failed
    end

    def destroy
      cookies.signed[:admin_id] = nil
      redirect_to new_admin_session_url, notice: t('flash.signed_out')
    end

    private

    def authenticated(admin)
      cookies.signed[:admin_id] = admin.id
      flash[:notice] = t('flash.signed_in')
      respond_to do |f|
        f.json { ok_resp }
        f.html { redirect_to admin_root_url }
      end
    end

    def auth_failed
      msg = 'Invalid email or password.'
      respond_to do |f|
        f.json { err_resp({ base: [msg] }) }
        f.html { redirect_to new_admin_session_url, alert: msg }
      end
    end
  end
end
