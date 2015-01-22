class AddBrokeAtToTaskTimes < ActiveRecord::Migration
  def change
    add_column :task_times, :broke_at, :datetime
  end
end
