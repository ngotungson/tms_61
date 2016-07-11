class Supervisor::SubjectsController < ApplicationController
  def index
    @subjects = Subject.page params[:page]
  end
end
