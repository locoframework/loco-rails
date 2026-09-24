# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    def index
      @users = perform(query: User::List, payload: { page: params[:page] }).val[:users]
    end

    def show
      @user = perform(query: User::Find, payload: { id: params[:id] }).val[:user]
    end

    def edit
      @user = perform(action: User::StartConfirmation, payload: { id: params[:id] }).val[:user]
    end

    def update
      res = perform(action: User::Update, payload: { id: params[:id], user: user_params })
      if res.ok
        success_response(200, flash: 'User updated!')
      else
        failure_response(400, res.val[:user].errors)
      end
    end

    def destroy
      perform(action: User::Destroy, payload: { id: params[:id] })
      redirect_to admin_users_path, notice: t('flash.user_destroyed')
    end

    private

    def user_params
      params.expect user: %i[email username password password_confirmation
                             confirmed]
    end
  end
end
