class UserCoursesController < ApplicationController
  load_and_authorize_resource
  before_action :load_course, :load_supervisor,:load_trainees, only: :show

  def index
    @user_courses = current_user.user_courses.page params[:page]
  end

  def show
    @subjects = Kaminari.paginate_array(@course.subjects.
      map{|subject| [subject, CourseSubject.find_by(@user_course.id, subject.id)]}).
      page params[:subject_page]
    @trainees = @trainees.page params[:trainee_page]
    @supervisors = @supervisors.page params[:supervisor_page]
    @current_tab = params[:current_tab]
  end

  private
  def load_course
    @course = @user_course.course
  end

  def load_trainees
    @trainees = @course.users.trainee
  end

  def load_supervisor
    @supervisors = @course.users.supervisor
  end
end
