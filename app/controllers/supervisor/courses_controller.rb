class Supervisor::CoursesController < ApplicationController
  load_and_authorize_resource
  before_action :load_supervisor, only: [:show]
  before_action :load_trainees, only: [:show, :update]
  before_action :load_subjects, except: [:index, :destroy, :show]

  def index
    @search = Course.ransack params[:q]
    @courses = @search.result.order(updated_at: :desc).page params[:page]
    attributes = %w(id name duration status)
    respond_to do |format|
      format.html
      format.csv {send_data @search.result.to_csv(attributes),
        filename: "courses-#{Date.today}.csv"}
      format.xls {send_file @search.result.to_excel(attributes),
        filename: "courses-#{Date.today}.xls"}
      format.xlsx {render xlsx: "index",filename: "courses.xlsx"}
    end
  end

  def show
    @subjects =  Kaminari.paginate_array(
      @course.subjects.map do |subject|
        [subject, CourseSubject.find_by(course_id: @course.id,
          subject_id: subject.id)]
      end).page params[:subject_page]
    @trainees = @trainees.page params[:trainee_page]
    @supervisors = @supervisors.page params[:supervisor_page]
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
    if params[:status]
      update_status
    else
      update_info
    end
  end

  def destroy
    if @course.destroy
      flash[:success] = t "controller.common_flash.delete_success",
        object_name: Course.name
    else
      flash[:danger] = t "controller.common_flash.delete_error",
        object_name: Course.name
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

  def load_trainees
    @trainees = @course.users.trainee
  end

  def load_supervisor
    @supervisors = @course.users.supervisor
  end

  def update_info
    if @course.update_attributes course_params
      @course.create_activity :update_info, owner: current_user
      flash.now[:success] = t "controller.common_flash.update_success",
        object_name: Course.name
      redirect_to supervisor_courses_url
    else
      render :edit
    end
  end

  def update_status
    if params[:status] == Course.statuses[:in_process].to_s
      if @trainees.in_course_process.blank?
        @course.update_attributes status: Course.statuses[:in_process]
        @course.update_attributes start_date: DateTime.now
        @course.create_activity :start, owner: current_user
        flash[:success] = t "controller.supervisor.course.update.started"
      else
        flash[:danger] = t "controller.supervisor.course.update.reject"
      end

    elsif params[:status] == Course.statuses[:closed].to_s
      @course.update_attributes status: Course.statuses[:closed]
      @course.update_attributes end_date: DateTime.now
      @course.create_activity :finish, owner: current_user
      flash[:success] = t "controller.supervisor.course.update.finished"
    end

    redirect_to supervisor_course_url(@course)
  end
end
