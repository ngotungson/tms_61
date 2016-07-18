class UserSubject < ActiveRecord::Base
  enum status: [:not_started, :in_process, :finished]

  belongs_to :user
  belongs_to :subject
  belongs_to :user_course
  has_many :user_tasks, dependent: :destroy
end
