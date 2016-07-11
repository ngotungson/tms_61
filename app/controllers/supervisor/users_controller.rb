class Supervisor::UsersController < ApplicationController
  before_action :authenticate_supervisor!
  before_action :load_user, only: [:edit, :update]

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

  private
  def user_params
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end
    params.require(:user).permit :name, :email, :password, :password_confirmation,
      :avatar, :role
  end

  def load_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t "controller.user.flash.notexist"
      redirect_to new_user_session_url
    end
  end
end
