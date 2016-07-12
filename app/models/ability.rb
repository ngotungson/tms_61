class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.supervisor?
      can :manage, :all
      cannot :destroy, User do |user|
        user.supervisor? || User.in_actived_course.include?(user)
      end
    else
      can :read, :all
    end
  end
end
