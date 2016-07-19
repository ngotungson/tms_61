class UserTask < ActiveRecord::Base
  include ActivityLog

  belongs_to :user
  belongs_to :task
  belongs_to :user_subject
end
