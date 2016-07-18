class CreateUserTasks < ActiveRecord::Migration
  def change
    create_table :user_tasks do |t|
      t.integer :user_id
      t.integer :task_id
      t.integer :user_subject_id
      t.integer :status, default: 0

      t.timestamps null: false
    end
  end
end
