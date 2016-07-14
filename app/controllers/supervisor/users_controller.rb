class Supervisor::UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = User.page params[:page]
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "controller.common_flash.create_success",
        object_name: User.name
      redirect_to supervisor_users_url
    else
      render :new
    end
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "controller.common_flash.update_success",
        object_name: User.name
      redirect_to supervisor_users_url
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controller.common_flash.delete_success",
        object_name: User.name
    else
      flash[:danger] = t "controller.common_flash.delete_error",
        object_name: User.name
    end
    redirect_to supervisor_users_url
  end

  private
  def user_params
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end
    params.require(:user).permit :name, :email, :password, :password_confirmation,
      :avatar, :role
  end
end
