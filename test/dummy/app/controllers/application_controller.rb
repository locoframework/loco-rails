# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Loco::Emitter
  include Ephemeron::ControllerAddons

  protect_from_forgery with: :exception # For APIs, you may want to use :null_session instead.

  helper_method :current_admin, :current_user

  private

  def current_admin
    return nil if cookies.signed[:admin_id].nil?
    return unless @current_admin ||= Admin.find_by(id: cookies.signed[:admin_id])

    Ephemeron.used @current_admin
  end

  def current_user
    return nil if cookies.signed[:user_id].nil?

    Ephemeron.used(@current_user) if @current_user ||= User.find_by(id: cookies.signed[:user_id])
  end

  def loco_permissions
    [current_user, current_admin]
  end

  def success_response(status, msg, data = nil, other = {})
    resp = { success: true, status: status, flash: { success: msg } }
    unless data.nil?
      resp[:data] = {}
      data.each { |key, val| resp[:data][key] = val }
    end
    other.each { |key, val| resp[key] = val } if other.any?
    render json: resp
  end

  def failure_response(status, errors)
    render json: { success: false, status: status, errors: errors }
  end

  def html_json_response(success, model, data = {})
    if success
      respond_to do |format|
        format.json { success_response 200, data[:notice_json], {} }
        format.html { redirect_to data[:redirect_to], notice: data[:notice_html] }
      end
    else
      respond_to do |format|
        format.json { failure_response 400, model.errors }
        format.html { render :edit }
      end
    end
  end
end
