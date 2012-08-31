require 'task_association_validator'

class Task < ActiveRecord::Base
  attr_accessible :content
  validates :content, presence: true
  validates :user, presence: true
  validates_with TaskAssociationValidator

  scope :open, where( closed_at: nil )
  
  belongs_to :user
  has_many :child_task_joiners, class_name: 'TaskJoiner', foreign_key: :parent_task_id, dependent: :destroy
  has_many :child_tasks, through: :child_task_joiners
  has_many :parent_task_joiners, class_name: 'TaskJoiner', foreign_key: :child_task_id, dependent: :destroy
  has_many :parent_tasks, through: :parent_task_joiners
  has_many :task_times
  has_many :task_amounts

  scope :prioritized, order: :priority

  def as_json( options )
    super( options.merge( include: :parent_task_joiners ) )
  end

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

  def start
    TaskTime.includes( :task ).where( ended_at: nil, 'tasks.user_id' => user_id ).each { |task_time| task_time.update_attributes! ended_at: Time.zone.now }
    task_times.create! started_at: Time.zone.now
  end

  def add_amount( amount = 1 )
    task_amounts.create! amount: amount, incurred_at: Time.zone.now
  end
  
  def close
    self.closed_at = Time.zone.now
    save!
  end
end
