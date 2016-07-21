class UserSubjectsController < ApplicationController
  load_and_authorize_resource

  def show
    @tasks = @user_subject.subject.tasks
    @user_id = @user_subject.user_id
    @tasks.each do |task|
      @user_subject.user_tasks.find_or_initialize_by task_id: task.id,
        user_id: @user_id
    end
    @activities = @user_subject.all_activities
      .page params[:activity_page]
  end

  def update
    if @user_subject.update_attributes user_subject_params
      flash[:success] = t "controller.common_flash.update_success",
        object_name: UserSubject.name
    else
      flash[:danger] = t "controller.common_flash.update_error",
        object_name: UserSubject.name
    end
    redirect_to :back
  end

  private
  def user_subject_params
    params.require(:user_subject).permit :user_id, :subject_id, :user_course_id,
     :status, user_tasks_attributes: [:id, :user_id, :task_id]
  end
end
