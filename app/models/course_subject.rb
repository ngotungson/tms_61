class CourseSubject < ActiveRecord::Base
  enum status: [:not_started, :in_process, :closed]

  belongs_to :course
  belongs_to :subject
end
