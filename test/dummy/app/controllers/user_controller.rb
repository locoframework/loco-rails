# frozen_string_literal: true

class UserController < ApplicationController
  before_action :authenticate

  layout 'user'

  private

  def user_opts
    { ars: { user: current_user } }
  end

  def authenticate
    redirect_to new_user_session_url unless current_user
  end
end
