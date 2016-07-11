(1..5).each do |trainee_id|
  User.create(name: "Trainee #{trainee_id}",
    email: "trainee#{trainee_id}@example.com",
    password: "123456",
    role: 1)
end

User.create(name: "Supervisor",
  email: "supervisor@example.com",
  password: "123456",
  role: 0)

(1..10).each do |course_id|
  Course.create(name: "Training Ruby on Rail phase #{course_id}",
    description: "Learning Ruby on rails phase #{course_id} with conplete Subjects",
    start_date: "2016-07-01",
    end_date: "2016-08-01")
end

(1..10).each do |subject_id|
  Subject.create(name: "Subject #{subject_id}",
    description: "You should complete tasks in subject #{subject_id}",
    duration: 7)
end
