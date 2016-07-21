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
end
