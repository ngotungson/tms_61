class Supervisor::SupervisorCoursesController < ApplicationController
  load_and_authorize_resource :course
  before_action :load_supervisor, only: :edit

  def edit
  end

  def update
    if @course.update_attributes course_params
      flash[:success] = t "controller.supervisor.assign_trainee.success"
      redirect_to supervisor_course_url @course
    else
      flash[:danger] = t "controller.supervisor.assign_supervisor.error"
      render :edit
    end
  end

  private
  def course_params
    params.require(:course).permit user_ids: []
  end

  def load_supervisor
    @users = User.supervisor
  end
end
