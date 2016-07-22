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

  def finish_course user, course
    @user = user
    @course = course
    mail to: @user.email, subject: @course.name
  end

  def monthly_report_to_supervisor supervisor, courses
    @supervisor = supervisor
    @courses = courses
    mail to: supervisor.email, subject: t("mail.subject_monthly_report")
  end
end
