class TaskJoiner < ActiveRecord::Base
  belongs_to :parent_task, class_name: 'Task'
  belongs_to :child_task, class_name: 'Task'
  attr_accessible :child_task_id, :parent_task_id, :multiplier

  validates :parent_task, presence: true
  validates :child_task, presence: true
end
