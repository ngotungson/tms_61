class UserCourse < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  has_many :user_subjects, dependent: :destroy

  paginates_per Settings.course.per_page

  after_create :send_email_assign, :send_email_before_end_course
  before_destroy :send_email_remove

  private
  def send_email_assign
    TraineeWorker.perform_async TraineeWorker::ASSIGN_TRAINEE,
      self.user_id, self.course_id
  end

  def send_email_remove
    TraineeWorker.perform_async TraineeWorker::REMOVE_TRAINEE,
      self.user_id, self.course_id
  end

  def send_email_before_end_course
    TraineeWorker.perform_at (self.course.end_date - 1.day),
      TraineeWorker::NOTIFY_FINISH, self.user_id, self.course_id
  end
end
