class UserMailer < ApplicationMailer
  default from: Settings.mail_from

  def assign_to_course user, course
    @user = user
    @course = course
    mail to: @user.email, subject: @course.name
  end

  def remove_from_course user, course
    @user = user
    @course = course
    mail to: @user.email, subject: @course.name
  end
end
