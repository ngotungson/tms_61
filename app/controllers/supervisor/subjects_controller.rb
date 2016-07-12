class Supervisor::SubjectsController < ApplicationController
  load_and_authorize_resource

  def index
    @subjects = Subject.page params[:page]
  end

  def show
    @tasks = @subject.tasks.page(params[:page]).per Settings.task.per_page
  end
end
