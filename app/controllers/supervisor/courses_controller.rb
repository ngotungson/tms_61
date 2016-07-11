class Supervisor::CoursesController < ApplicationController
  def index
    @courses = Course.page params[:page]
  end
end
