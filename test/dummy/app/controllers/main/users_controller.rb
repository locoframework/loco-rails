# frozen_string_literal: true

module Main
  class UsersController < MainController
    def new
      render
    end

    def create
      res = perform(action: User::Create, payload: { user: user_params })
      user = res.val[:user]
      res.ok ? ok_resp_for_create(user) : err_resp(400, user.errors)
    end

    private

    def user_params
      params.expect(user: %i[email password password_confirmation username])
    end

    def ok_resp_for_create(user)
      ok_resp(
        201,
        flash: 'Signed up!',
        data: {
          id: user.id,
          notice: 'Welcome! You have signed up successfully.',
          access_token: user.token
        },
        access_token: user.token
      )
    end
  end
end
