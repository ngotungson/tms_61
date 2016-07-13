class Supervisor::CoursesController < ApplicationController
  load_and_authorize_resource
  before_action :load_subjects, except: [:show, :destroy]

  def index
    @courses = Course.page params[:page]
  end

  def show
    @subjects = @course.subjects.page params[:subject_page]
    @trainees = @course.users.merge(User.trainee).page params[:trainee_page]
    @supervisors = @course.users.merge(User.supervisor).page params[:supervisor_page]
    @current_tab = params[:current_tab]
  end

  def new
    @course = Course.new
  end

  def edit
  end

  def create
    if @course.save
      flash[:success] = t "controller.common_flash.create_success",
        object_name: Course.name
      redirect_to supervisor_courses_url
    else
      render :new
    end
  end

  def update
    if @course.update_attributes course_params
      flash.now[:success] = t "controller.common_flash.update_success",
        object_name: Course.name
      redirect_to supervisor_courses_url
    else
      render :edit
    end
    redirect_to supervisor_courses_url
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

  private
  def course_params
    params.require(:course).permit :name, :description, :start_date,
      :end_date, subject_ids: [], user_ids: []
  end

  def load_subjects
    @subjects = Subject.page params[:page]
  end
end
