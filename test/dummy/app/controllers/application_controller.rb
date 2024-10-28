# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Loco::Emitter

  protect_from_forgery with: :exception # For APIs, you may want to use :null_session instead.

  helper_method :current_admin, :current_user

  private

  def current_admin
    return nil if cookies.signed[:admin_id].nil?

    @current_admin ||= Admin::SupportMember.find_by id: cookies.signed[:admin_id]
  end

  def current_user
    return nil if cookies.signed[:user_id].nil?

    @current_user ||= User.find_by id: cookies.signed[:user_id]
  end

  def loco_permissions
    [current_user, current_admin]
  end

  def success_response(status, msg, data = nil, other = {})
    resp = { success: true, status:, flash: { success: msg } }
    unless data.nil?
      resp[:data] = {}
      data.each { |key, val| resp[:data][key] = val }
    end
    other.each { |key, val| resp[key] = val }
    render json: resp
  end

  def failure_response(status, errors)
    render json: { success: false, status:, errors: }
  end
end
