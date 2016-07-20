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
      can :update, UserSubject
    end
  end
end
