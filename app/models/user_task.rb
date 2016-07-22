class UserTask < ActiveRecord::Base
  include ActivityLog
  tracked only: :create, owner: Proc.new{|controller| controller.current_user}

  belongs_to :user
  belongs_to :task
  belongs_to :user_subject
  after_create :finish_subject, if: :all_tasks_was_finished?

  scope :in_this_month, -> do
    where("cast(strftime('%m', created_at) as int) = #{Time.now.month}")
  end

  private
  def all_tasks_was_finished?
    user_subject.user_tasks.count == user_subject.subject.tasks.count
  end

  def finish_subject
    user_subject.update_attributes status: :finished
  end
end
