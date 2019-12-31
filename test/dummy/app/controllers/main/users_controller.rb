# frozen_string_literal: true

class Main::UsersController < MainController
  def new
    render
  end

  def create
    user = User.new user_params
    if user.save
      token = SecureRandom.hex 10
      emit user, :created, for: Admin
      Connection.create! obj: user, token: token
      render json: {
        success: true,
        status: 201,
        flash: { success: 'Signed up!' },
        data: { id: user.id, notice: 'Welcome! You have signed up successfully.' },
        access_token: token
      }
    else
      render json: { success: false, status: 400, errors: user.errors }
    end
  end

  private

    def user_params
      params.require(:user).permit :email, :password, :password_confirmation, :username
    end
end
