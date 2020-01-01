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
      cookies.signed[:admin_id] = admin.id
      flash[:notice] = 'Successfully signed in.'
      respond_to do |f|
        f.json { render json: { success: true } }
        f.html { redirect_to admin_root_url }
      end
    end

    def destroy
      cookies.signed[:admin_id] = nil
      redirect_to new_admin_session_url, notice: 'Successfully signed out.'
    end

    private

      def auth_failed
        respond_to do |f|
          f.json { render json: { errors: { base: ['Invalid email or password.'] } } }
          f.html { redirect_to new_admin_session_url, alert: 'Invalid email or password.' }
        end
      end
  end
end
