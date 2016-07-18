class UserSubjectsController < ApplicationController
  load_and_authorize_resource
  before_action :load_user_subject, only: :update

  def update
    if @user_subject.update_attributes user_subject_params
      flash[:success] = t "controller.common_flash.update_success",
        object_name: UserSubject.name
    else
      flash[:danger] = t "controller.common_flash.update_error",
        object_name: UserSubject.name
    end
    redirect_to user_course_url @user_subject.user_course.id
  end

  private
  def user_subject_params
    params.require(:user_subject).permit :user_id, :subject_id,
      :user_course_id, :status
  end

  def load_user_subject
    @user_subject = UserSubject.find_by user_id: params[:user_id], subject_id:
      params[:subject_id], user_course_id: params[:user_course_id]
  end
end
