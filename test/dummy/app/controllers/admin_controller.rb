# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate

  layout 'admin'

  private

  def authenticate
    redirect_to new_admin_session_url unless current_admin
  end
end
