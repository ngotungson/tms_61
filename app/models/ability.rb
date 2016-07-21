class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.supervisor?
      can :manage, :all
      cannot :destroy, User do |user|
        user.supervisor? || User.in_course_process.include?(user)
      end
      cannot :destroy, Course do |course|
        course.in_process? || course.closed?
      end
    else
      can :read, :all
      can :update, User, id: user.id
      can :read, UserCourse, user_id: user.id
      can [:update, :read], User, id: user.id
      can :read, UserSubject, user_id: user.id
      can :update, UserSubject, course: {status: Course.statuses[:in_process]}
      cannot :update, UserSubject do |user_subject|
        user_subject.course.not_started? || user_subject.course.closed?
      end
      cannot :create, UserTask do |user_task|
        user_task.user_subject.not_started? || user_task.user_subject.closed?
      end
    end
  end
end
