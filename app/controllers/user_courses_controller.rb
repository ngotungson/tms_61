class UserCoursesController < ApplicationController
  load_and_authorize_resource
  before_action :load_course, only: [:index, :show]

  def index
    @user_courses = UserCourse.page params[:page]
  end

  def show
    @user_subjects = @user_course.user_subjects.page(params[:page])
      .per Settings.user.user_subject.per_page
  end

  private
  def load_course
    @course = Course.find_by id: params[:id]
  end
end
