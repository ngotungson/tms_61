class Supervisor::UserCoursesController < ApplicationController
  load_and_authorize_resource :course

  def edit
    if @course.not_started?
      @trainees = User.trainee
    else
      @trainees = User.trainee.not_in_course_process @course.id
    end
    @supervisors = User.supervisor
    @course_users = @course.users
  end

  def update
    if @course.update_attributes course_params
      flash[:success] = t "controller.supervisor.assign_trainee.success"
      redirect_to supervisor_course_url @course
    else
      flash[:danger] = t "controller.supervisor.assign_trainee.error"
      render :edit
    end
  end

  private
  def course_params
    params[:course] = {user_ids: []} if params[:course].nil?
    params.require(:course).permit user_ids: []
  end
end
