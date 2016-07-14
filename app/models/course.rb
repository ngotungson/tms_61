class Course < ActiveRecord::Base
  enum status: [:start, :in_process, :closed]

  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses, dependent: :destroy
  has_many :course_subjects, dependent: :destroy
  has_many :subjects, through: :course_subjects, dependent: :destroy

  paginates_per Settings.course.per_page

  validates :name, presence: true, length: {minimum: 6, maximum: 90}
  validates :description, presence: true, length: {minimum: 9}
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :subject_ids, presence: true
  validate :check_date

  def duration
    "#{start_date.to_formatted_s :short} : #{end_date.to_formatted_s :short}"
  end

  private
  def check_date
    return if self.end_date.blank? || self.start_date.blank?
    if self.end_date < self.start_date
      self.errors.add :end_date, I18n.t("model.course.must_be_after_or_equal_end_date")
    end
    if self.start_date < Date.today
      self.errors.add :start_date, I18n.t("model.course.not_in_past")
    end
  end
end
