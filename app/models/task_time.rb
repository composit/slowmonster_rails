class TaskTime < ActiveRecord::Base
  belongs_to :task
  attr_accessible :ended_at, :started_at, :task_id

  validates :task, presence: true
  validates :started_at, presence: true

  scope :current, where(ended_at: nil)

  def as_json(options)
    super(options.merge(methods: [:go_seconds, :break_seconds]))
  end

  def stop
    update_attribute(:ended_at, Time.zone.now)
  end

  def go_seconds
    seconds = task.go_seconds - seconds_since_started
    seconds = seconds.round.to_i
    seconds > 0 ? seconds : 0
  end

  def break_seconds
    seconds = (task.go_seconds + task.break_seconds) - seconds_since_started
    seconds = task.break_seconds if seconds > task.break_seconds
    seconds = seconds.round.to_i
    seconds > 0 ? seconds : 0
  end

  private
    def seconds_since_started
      Time.zone.now - started_at
    end
end
