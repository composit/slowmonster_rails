require 'task_association_validator'

class Task < ActiveRecord::Base
  attr_accessible :content
  validates :content, presence: true
  validates :user, presence: true
  validates_with TaskAssociationValidator
  
  belongs_to :user
  has_many :child_task_joiners, class_name: 'TaskJoiner', foreign_key: :parent_task_id, dependent: :destroy
  has_many :child_tasks, through: :child_task_joiners
  has_many :parent_task_joiners, class_name: 'TaskJoiner', foreign_key: :child_task_id, dependent: :destroy
  has_many :parent_tasks, through: :parent_task_joiners

  def ancestor_task_ids
    parent_tasks.inject( parent_task_ids ) do |ids, parent_task|
      ids += parent_task.ancestor_task_ids
    end
  end

  def descendant_task_ids
    child_tasks.inject( child_task_ids ) do |ids, child_task|
      ids += child_task.descendant_task_ids
    end
  end
end
