# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_admin, :current_user

  private

  def current_admin
    return nil if cookies.signed[:admin_id].nil?

    if defined?(@current_admin)
      @current_admin
    else
      @current_admin = Admin::SupportMember.find_by(id: cookies.signed[:admin_id])
    end
  end

  def current_user
    return nil if cookies.signed[:user_id].nil?

    if defined?(@current_user)
      @current_user
    else
      @current_user = User.find_by(id: cookies.signed[:user_id])
    end
  end

  def loco_permissions
    [current_user, current_admin]
  end

  def success_response(status, flash:, data: nil, **other)
    resp = { ok: true, status:, flash: { success: flash } }
    resp[:data] = data unless data.nil?
    render json: resp.merge(other)
  end

  def failure_response(status, errors)
    render json: { ok: false, status:, errors: }
  end
end
