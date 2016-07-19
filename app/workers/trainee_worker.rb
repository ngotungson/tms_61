class TraineeWorker
  include Sidekiq::Worker

  ASSIGN_TRAINEE = Settings.assign_trainee
  REMOVE_TRAINEE = Settings.remove_trainee

  def perform action, trainee_id, course_id
    case action
    when ASSIGN_TRAINEE
      send_email_when_trainee_assigned trainee_id, course_id
    when REMOVE_TRAINEE
      send_email_when_trainee_removed trainee_id, course_id
    end
  end

  private
  def send_email_when_trainee_assigned trainee_id, course_id
    trainee = User.find_by id: trainee_id
    course = Course.find_by id: course_id
    UserMailer.assign_to_course(trainee, course).deliver_now
  end

  def send_email_when_trainee_removed trainee_id, course_id
    trainee = User.find_by id: trainee_id
    course = Course.find_by id: course_id
    UserMailer.remove_from_course(trainee, course).deliver_now
  end
end
