class UserCourse < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  has_many :user_subjects, dependent: :destroy

  paginates_per Settings.course.per_page
end
