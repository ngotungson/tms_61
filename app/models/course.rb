class Course < ActiveRecord::Base
  enum status: [:start, :in_process, :closed]

  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses, dependent: :destroy
  has_many :course_subjects, dependent: :destroy
  has_many :subjects, through: :course_subjects, dependent: :destroy

  paginates_per Settings.course.per_page

  def duration
    "#{start_date.to_formatted_s :short} :
      #{end_date.to_formatted_s :short}"
  end
end
