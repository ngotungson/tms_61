class Subject < ActiveRecord::Base
  has_many :user_subjects, dependent: :destroy
  has_many :users, through: :user_subjects
  has_many :tasks, dependent: :destroy
  has_many :course_subjects, dependent: :destroy
  has_many :courses, through: :course_subjects

  paginates_per Settings.subject.per_page
  accepts_nested_attributes_for :tasks, allow_destroy: true

  validates :name, presence: true, length: {minimum: 6, maximum: 90}
  validates :description, presence: true, length: {minimum: 9}
  validates :duration, presence:true, numericality: {only_integer: true,
    greater_than: 0, less_than_or_equal_to: 30}
  validates_associated :tasks
  validate :check_tasks

  private
  def check_tasks
    tasks = self.tasks.reject {|task| task.marked_for_destruction?}
    if tasks.combination(2).any? {|task1, task2| task1.name == task2.name}
      self.errors.add :tasks, I18n.t("model.subject.error.must_be_diference")
    end
    if tasks.count < Settings.least_task
      self.errors.add :tasks, I18n.t("model.subject.error.at_least_1")
    end
  end
end
