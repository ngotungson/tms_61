class UserSubject < ActiveRecord::Base

  enum status: [:not_started, :in_process, :finished]

  belongs_to :user
  belongs_to :subject
  belongs_to :course
  belongs_to :user_course
  has_many :user_tasks, dependent: :destroy

  accepts_nested_attributes_for :user_tasks, allow_destroy: true,
    reject_if: proc{|attribute|  attribute[:task_id].nil?}

  def all_activities
    PublicActivity::Activity.where(trackable_id: user_tasks.ids,
      trackable_type: UserTask.name, ).order("created_at desc")
  end

  def status_label
    if self.not_started?
      Settings.user_subject.status_label.not_started
    elsif self.in_process?
      Settings.user_subject.status_label.in_process
    elsif self.finished?
      Settings.user_subject.status_label.finished
    end
  end

  def status_content
    if self.not_started?
      I18n.t "model.user_subject.label.new"
    elsif self.in_process?
      I18n.t "model.user_subject.label.in_process"
    elsif self.finished?
      I18n.t "model.user_subject.label.finished"
    end
  end

  def user_course
    UserCourse.find_by(user_id: user_id, course_id: course_id)
  end
end
