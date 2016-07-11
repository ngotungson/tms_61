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
