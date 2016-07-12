class Supervisor::SubjectsController < ApplicationController
  load_and_authorize_resource
  before_action :load_subject, only: [:edit, :update]

  def index
    @subjects = Subject.page params[:page]
  end

  def show
    @tasks = @subject.tasks.page(params[:page]).per Settings.task.per_page
  end

  def new
    @subject = Subject.new
    Settings.build_task.times {@subject.tasks.new}
  end

  def edit
  end

  def create
    @subject = Subject.new subject_params
    if @subject.save
      flash[:success] = t "controller.supervisor.subject.create_success"
      redirect_to supervisor_root_url
    else
      render :new
    end
  end

  def update
    if @subject.update_attributes subject_params
      flash.now[:success] = t "controller.supervisor.subject.update_success"
      redirect_to supervisor_root_url
    else
      render :edit
    end
  end

  private
  def subject_params
    params.require(:subject).permit :name, :description, :duration,
      tasks_attributes: [:id, :name, :subject_id, :_destroy]
  end

  def load_subject
    @subject = Subject.find_by id: params[:id]
  end
end
