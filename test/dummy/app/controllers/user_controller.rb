class UserController < ApplicationController
  before_action :authenticate

  layout 'user'

  private

    def authenticate
      if not current_user
        redirect_to new_user_session_url
      end
    end
end