# frozen_string_literal: true

class Admin
  class SessionsController < ApplicationController
    def new
      render
    end

    def create
      admin = Admin.find_by email: params[:email]
      auth_failed && return if admin.nil?
      auth_failed && return unless admin.authenticate params[:password]

      auth_succeeded(admin)
    end

    def destroy
      cookies.signed[:admin_id] = nil
      redirect_to new_admin_session_url, notice: 'Successfully signed out.'
    end

    private

    def auth_succeeded(admin)
      cookies.signed[:admin_id] = admin.id
      flash[:notice] = 'Successfully signed in.'
      respond_to do |f|
        f.json { render json: { success: true } }
        f.html { redirect_to admin_root_url }
      end
    end

    def auth_failed
      msg = 'Invalid email or password.'
      respond_to do |f|
        f.json { render json: { errors: { base: [msg] } } }
        f.html { redirect_to new_admin_session_url, alert: msg }
      end
    end
  end
end
