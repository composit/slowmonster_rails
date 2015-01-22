class TaskAmount < ActiveRecord::Base
  belongs_to :task
  attr_accessible :amount, :incurred_at

  validates :task, presence: true
  validates :amount, presence: true
  validates :incurred_at, presence: true
end
