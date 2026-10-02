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

  def perform(action:, payload: {}, opts: {})
    payload = payload.merge((opts[:ars] || {}).to_h { |k, v| [:"#{k}_id", v.id] })
    action.method(:call).arity == 1 ? action.(payload) : action.(payload, opts)
  end

  def ok_resp(flash: nil, data: nil, **other)
    render json: { ok: true, flash: flash && { success: flash }, data: }.compact.merge(other)
  end

  def err_resp(errors)
    render json: { ok: false, errors: }
  end
end
