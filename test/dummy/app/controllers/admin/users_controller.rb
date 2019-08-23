class Admin::UsersController < AdminController
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json do
        @users = User.order("created_at DESC").paginate page: params[:page], per_page: 10
        @count = User.count
      end
    end
  end

  def show
    respond_to do |format|
      format.html{ render }
      format.json{ set_user }
    end
  end

  def edit
    return if @user.confirmed?
    connection = Connection.for_obj(@user).last
    return if connection.nil?
    emit @user, :confirming, for: connection.token
  end

  def update
    if @user.update user_params
      if @user.confirmed? && connection = Connection.for_obj(@user).last
        emit @user, :confirmed, for: connection.token
        connection.destroy
      end
      render json: {success: true, status: 200, flash: {success: 'User updated!'}}
    else
      render json: {success: false, status: 400, errors: @user.errors}
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "User was successfully destroyed."
  end

  private

    def set_user
      @user = if params[:id].present?
        User.find params[:id]
      else
        User.new
      end
    end

    def user_params
      params.require(:user).permit :email, :username, :password, :password_confirmation, :confirmed
    end
end