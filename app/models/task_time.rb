class TaskTime < ActiveRecord::Base
  belongs_to :task
  attr_accessible :ended_at, :started_at

  validates :task, presence: true
  validates :started_at, presence: true
end
