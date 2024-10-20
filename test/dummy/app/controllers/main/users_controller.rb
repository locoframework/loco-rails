# frozen_string_literal: true

module Main
  class UsersController < MainController
    def new
      render
    end

    def create
      user = User.new(user_params)
      if user.save
        token = SecureRandom.hex(10)
        emit(user, :created, to: Admin::SupportMember)
        Connection.create!(obj: user, token:)
        success_response_for_create(user, token)
      else
        failure_response(400, user.errors)
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :username)
    end

    def success_response_for_create(user, token)
      success_response(
        201,
        'Signed up!',
        {
          id: user.id,
          notice: 'Welcome! You have signed up successfully.'
        },
        access_token: token
      )
    end
  end
end
