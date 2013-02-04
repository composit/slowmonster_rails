class TaskJoiner < ActiveRecord::Base
  belongs_to :parent_task, class_name: 'Task'
  belongs_to :child_task, class_name: 'Task'
  attr_accessible :child_task_id, :parent_task_id, :multiplier

  def total_child_value( start_threshold, end_threshold )
    child_task.total_value( start_threshold, end_threshold ) * multiplier
  end
end
