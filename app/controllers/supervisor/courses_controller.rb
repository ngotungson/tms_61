class Supervisor::CoursesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_supervisor!

  def index
    @courses = Course.page params[:page]
  end

  def show
    @subjects = @course.subjects.page params[:subject_page]
    @trainees = @course.users.merge(User.trainee).page params[:trainee_page]
    @supervisors = @course.users.merge(User.supervisor).page params[:supervisor_page]
    @current_tab = params[:current_tab]
  end

  def destroy
    if @course.start?
      if @course.destroy
        flash[:success] = t "controller.common_flash.delete_success",
          object_name: Course.name
      else
        flash[:danger] = t "controller.common_flash.delete_error",
          object_name: Course.name
      end
    else
      flash[:danger] = t "controller.supervisor.course.destroy.not_delete_course_started"
    end
    redirect_to supervisor_courses_url
  end
end
