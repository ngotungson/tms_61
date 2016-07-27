class Supervisor::UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @search = User.ransack params[:q]
    @users = @search.result.order(updated_at: :desc).page params[:page]
    attributes = %w(id name email role)
    respond_to do |format|
      format.html
      format.csv {send_data @search.result.to_csv(attributes),
        filename: "users-#{Date.today}.csv"}
      format.xls {send_file @search.result.to_excel(attributes),
        filename: "users-#{Date.today}.xls"}
      format.xlsx {render xlsx: "index",filename: "users.xlsx"}
    end
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

  def import
    attributes = %w(name email password role)
    begin
      User.import(params[:file], attributes)
    rescue => e
      flash[:danger] = e.message
    else
      flash[:success] = t "controller.supervisor.user.import.success"
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
