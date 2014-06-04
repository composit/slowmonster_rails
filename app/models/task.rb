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
    super(options.merge(include: [:parent_task_joiners, :child_task_joiners]))
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

  def add_amount( amount = 1 )
    task_amounts.create! amount: amount, incurred_at: Time.zone.now
  end
  
  def close
    self.closed_at = Time.zone.now
    save!
  end

  def total_value( start_threshold = nil, end_threshold = nil )
    #TODO move this into the report or report_task
    self_seconds( start_threshold, end_threshold ) + self_amount( start_threshold, end_threshold ) + childs_total( start_threshold, end_threshold )
  end

  def daily_average_since(time)
    total_value(time) / (Time.zone.now.to_date - time.to_date)
  end

  def chart_numbers
    [daily_average_since(4.weeks.ago), daily_average_since(2.weeks.ago), daily_average_since(1.week.ago), daily_average_since(1.day.ago)]
  end

  private
    def self_seconds( start_threshold, end_threshold )
      times = task_times
      times = times.where( 'ended_at is null or ended_at > ?', start_threshold ) if start_threshold
      times = times.where( 'started_at <= ?', end_threshold ) if end_threshold
      self_seconds = times.inject( 0.0 ) do |sum_seconds, task_time|
        task_end_time = task_time.ended_at || Time.zone.now
        start_time = ( start_threshold && task_time.started_at < start_threshold ) ? start_threshold : task_time.started_at
        end_time = ( end_threshold && task_end_time > end_threshold ) ? end_threshold : task_end_time
        sum_seconds += ( end_time - start_time )
      end
      ( ( self_seconds / 3600.0 ) * 100 ).round / 100.0
    end

    def self_amount( start_threshold, end_threshold )
      amounts = task_amounts
      amounts = amounts.where( 'incurred_at >= ?', start_threshold ) if start_threshold
      amounts = amounts.where( 'incurred_at < ?', end_threshold ) if end_threshold
      self_amount = amounts.inject( 0.0 ) do |sum_amount, task_amount|
        sum_amount += task_amount.amount
      end
    end

    def childs_total( start_threshold, end_threshold )
      childs_total = child_task_joiners.inject( 0.0 ) do |sum_total, child_task_joiner|
        sum_total + child_task_joiner.total_child_value( start_threshold, end_threshold )
      end
      ( ( childs_total ) * 100 ).round / 100.0
    end
end
