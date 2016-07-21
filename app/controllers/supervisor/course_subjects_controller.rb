class Supervisor::CourseSubjectsController < ApplicationController
  load_and_authorize_resource
  before_action :load_course_subject, only: :update

  def update
    if @course_subject.update_attributes course_subject_params
      flash[:success] = t "controller.common_flash.update_success",
        object_name: CourseSubject.name
      if params[:course_subject][:status].present?
        if params[:course_subject][:status] == Settings.course_subject.status.in_process
          @course_subject.create_activity :start, owner: current_user
        elsif params[:course_subject][:status] == Settings.course_subject.status.closed
          @course_subject.create_activity :finish, owner: current_user
        end
      end
    else
      flash[:danger] = t "controller.common_flash.update_error",
        object_name: CourseSubject.name
    end
    redirect_to supervisor_course_url @course_subject.course_id
  end

  private
  def course_subject_params
    params.require(:course_subject).permit :course_id, :subject_id, :status
  end

  def load_course_subject
    @course_subject = CourseSubject.find_by(course_id: params[:course_id],
      subject_id: params[:subject_id])
  end
end
