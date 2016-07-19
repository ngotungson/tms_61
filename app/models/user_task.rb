class UserTask < ActiveRecord::Base
  include ActivityLog

  belongs_to :user
  belongs_to :task
  belongs_to :user_subject
  after_create :finish_subject, if: :all_tasks_was_finished?

  private
  def all_tasks_was_finished?
    user_subject.user_tasks.count == user_subject.subject.tasks.count
  end

  def finish_subject
    user_subject.update_attributes status: :finished
  end
end
