# frozen_string_literal: true

module Main
  class UsersController < MainController
    def new
      render
    end

    def create
      user = User.new(user_params)
      if user.save
        Loco.emit({ event: :created }, subject: user, to: Admin::SupportMember)
        success_response_for_create(user)
      else
        failure_response(400, user.errors)
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :username)
    end

    def success_response_for_create(user)
      success_response(
        201,
        'Signed up!',
        {
          id: user.id,
          notice: 'Welcome! You have signed up successfully.',
          access_token: user.token
        },
        access_token: user.token
      )
    end
  end
end
