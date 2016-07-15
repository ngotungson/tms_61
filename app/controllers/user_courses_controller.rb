class UserCoursesController < ApplicationController
  load_and_authorize_resource

  def index
    @user_courses = UserCourse.page params[:page]
  end
end
