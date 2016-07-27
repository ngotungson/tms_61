class Supervisor::SubjectsController < ApplicationController
  load_and_authorize_resource

  def index
    @search = Subject.ransack params[:q]
    @subjects = @search.result.order(updated_at: :desc).page params[:page]
    attributes = %w(id name duration)
    respond_to do |format|
      format.html
      format.csv {send_data @search.result.to_csv(attributes),
        filename: "subjects-#{Date.today}.csv"}
      format.xls {send_file @search.result.to_excel(attributes),
        filename: "subjects-#{Date.today}.xls"}
      format.xlsx {render xlsx: "index",filename: "subjects.xlsx"}
    end
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
    if @subject.save
      flash[:success] = t "controller.common_flash.create_success",
        object_name: Subject.name
      redirect_to supervisor_subjects_url
    else
      render :new
    end
  end

  def update
    if @subject.update_attributes subject_params
      flash.now[:success] = t "controller.common_flash.update_success",
        object_name: Subject.name
      redirect_to supervisor_subjects_url
    else
      render :edit
    end
  end

  def destroy
    if @subject.destroy
      flash[:success] = t "controller.common_flash.delete_success",
        object_name: Subject.name
    else
      flash[:danger] = t "controller.common_flash.delete_error",
        object_name: Subject.name
    end
    redirect_to supervisor_subjects_url
  end

  private
  def subject_params
    params.require(:subject).permit :name, :description, :duration,
      tasks_attributes: [:id, :name, :subject_id, :_destroy]
  end
end
