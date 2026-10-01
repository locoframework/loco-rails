# frozen_string_literal: true

module Main
  class UsersController < MainController
    def new
      render
    end

    def create
      res = perform(action: User::Create, payload: { user: user_params })
      user = res.val[:user]
      return err_resp(400, user.errors) unless res.ok

      ok_resp(
        201,
        flash: 'Signed up!',
        data: { id: user.id, notice: 'Welcome! You have signed up successfully.' },
        access_token: user.token
      )
    end

    private

    def user_params
      params.expect(user: %i[email password password_confirmation username])
    end
  end
end
