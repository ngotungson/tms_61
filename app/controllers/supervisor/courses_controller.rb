class Supervisor::CoursesController < ApplicationController
  before_action :authenticate_supervisor!
  before_action :load_course, only: :show

  def index
    @courses = Course.page params[:page]
  end

  def show
    @subjects = @course.subjects.page params[:subject_page]
    @trainees = @course.users.merge(User.trainee).page params[:trainee_page]
    @supervisors = @course.users.merge(User.supervisor).page params[:supervisor_page]
    @current_tab = params[:current_tab]
  end

  private
  def load_course
    @course = Course.find_by id: params[:id]
    unless @course
      flash[:danger] = t ".notfound"
      redirect_to supervisor_courses_url
    end
  end
end
