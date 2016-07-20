class CourseSubject < ActiveRecord::Base
  include ActivityLog

  enum status: [:not_started, :in_process, :closed]

  belongs_to :course
  belongs_to :subject

  def status_label
    if self.not_started?
      Settings.course_subject.status_label.not_started
    elsif self.in_process?
      Settings.course_subject.status_label.in_process
    elsif self.closed?
      Settings.course_subject.status_label.closed
    end
  end

  def status_content
    if self.not_started?
      I18n.t "model.course_subject.label.new"
    elsif self.in_process?
      I18n.t "model.course_subject.label.in_process"
    elsif self.closed?
      I18n.t "model.course_subject.label.closed"
    end
  end
end
