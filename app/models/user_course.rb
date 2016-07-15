class UserCourse < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  paginates_per Settings.course.per_page
end
