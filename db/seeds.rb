(1..3).each do |supervisor_id|
  User.create(name: "Supervisor #{supervisor_id}",
    email: "supervisor#{supervisor_id}@example.com",
    password: "123456",
    role: 0)
end

(1..10).each do |trainee_id|
  User.create(name: "Trainee #{trainee_id}",
    email: "trainee#{trainee_id}@example.com",
    password: "123456",
    role: 1)
end

# (1..5).each do |course_id|
#   Course.create(name: "Training Ruby on Rail phase #{course_id}",
#     description: "Learning Ruby on rails phase #{course_id} with conplete Subjects",
#     start_date: "2016-10-01",
#     end_date: "2016-12-01",
#     status: 0)
# end

# (1..5).each do |course_id|
#   Course.create(name: "Training Ruby on Rail phase #{course_id}",
#     description: "Learning Ruby on rails phase #{course_id} with conplete Subjects",
#     start_date: "2016-10-01",
#     end_date: "2016-12-01",
#     status: 1)
# end

# # (1..10).each do |subject_id|
# #   Subject.create(name: "Subject #{subject_id}",
# #     description: "You should complete tasks in subject #{subject_id}",
# #     duration: 7)
# # end

# # (1..10).each do |subject_id|
# #   (1..5).each do |task_id|
# #     Task.create(name: "Task #{task_id} - S #{subject_id}",
# #       description: "Complete #{task_id} of subject#{subject_id}",
# #       subject_id: subject_id)
# #   end
# # end

# (1..6).each do |id|
#   UserCourse.create(course_id: 1, user_id: "#{id}")
# end
