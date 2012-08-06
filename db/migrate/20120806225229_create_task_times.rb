class CreateTaskTimes < ActiveRecord::Migration
  def change
    create_table :task_times do |t|
      t.datetime :started_at
      t.datetime :ended_at
      t.references :task

      t.timestamps
    end
    add_index :task_times, :task_id
  end
end
