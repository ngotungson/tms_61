class Course < ActiveRecord::Base
  include ActivityLog
  tracked only: :create, owner: Proc.new{|controller| controller.current_user}

  enum status: [:not_started, :in_process, :closed]

  has_many :user_courses, dependent: :destroy
  has_many :users, through: :user_courses, dependent: :destroy
  has_many :course_subjects, dependent: :destroy
  has_many :user_subjects, dependent: :destroy
  has_many :subjects, through: :course_subjects, dependent: :destroy

  paginates_per Settings.course.per_page

  validates :name, presence: true, length: {minimum: 6, maximum: 90}
  validates :description, presence: true, length: {minimum: 9}
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :subject_ids, presence: true
  validate :check_date

  before_create :set_not_started_status
  after_update :create_user_subject, if: -> {self.in_process?}
  after_update :finish_subjects, if: -> {self.closed?}

  COURSE_ACTIVITY = "(trackable_id = :course_id and trackable_type = 'Course')
    OR (trackable_type = 'CourseSubject' and trackable_id in
    (select distinct course_subjects.id from course_subjects
    where course_subjects.course_id = :course_id))"

  def all_activities
    PublicActivity::Activity.where(COURSE_ACTIVITY, course_id: id)
  end

  scope :in_this_month, -> do
    where("(cast(strftime('%m', start_date) as int) <= #{Time.now.month}
      AND cast(strftime('%m', end_date) as int) >= #{Time.now.month})")
      .where.not(status: Course.statuses[:not_started])
  end

  def duration
    "#{start_date.to_formatted_s :short} : #{end_date.to_formatted_s :short}"
  end

  def status_content
    if self.not_started?
      I18n.t "model.course.label.new"
    elsif self.in_process?
      I18n.t "model.course.label.in_process"
    elsif self.closed?
      I18n.t "model.course.label.closed"
    end
  end

  def status_label
    if self.not_started?
      Settings.course.status_label.not_started
    elsif self.in_process?
      Settings.course.status_label.in_process
    elsif self.closed?
      Settings.course.status_label.closed
    end
  end

  private
  def set_not_started_status
    self.status = Course.statuses[:not_started]
  end

  def create_user_subject
    self.users.trainee.each do |trainee|
      self.subjects.each do |subject|
        UserSubject.where(user_id: trainee.id,
          subject_id: subject.id, course_id: id).first_or_create
      end
    end
  end

  def finish_subjects
    course_subjects.each do |course_subject|
      course_subject.update_attributes status: UserSubject.statuses[:finished]
    end
  end

  def check_date
    return if self.end_date.blank? || self.start_date.blank?
    if self.end_date < self.start_date
      self.errors.add :end_date, I18n.t("model.course.must_be_after_or_equal_end_date")
    end
    if self.start_date < Date.today
      self.errors.add :start_date, I18n.t("model.course.not_in_past")
    end
    duration = 0;
    self.subjects.each do |subject|
      duration += subject.duration
    end
    if duration > (self.end_date.to_date - self.start_date.to_date).to_i
      self.errors.add :end_date, I18n.t("model.course.duration")
    end
    if self.start_date.year > 3000 || end_date.year > 3000
      self.errors.add :start_date, I18n.t("model.course.year_too_big")
    end
  end
end
