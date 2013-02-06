class ReportTask < ActiveRecord::Base
  belongs_to :task
  belongs_to :report
  attr_accessible :multiplier

  validates :task, presence: true
  validates :report, presence: true
  
  after_initialize :set_multiplier

  def task_content
    task.content if task
  end

  def totals_over_time
    0.upto( report.duration - 1 ).map do |offset|
      start_time = report.calculated_started_at + eval( "#{offset}.#{report.unit}" )
      end_time = start_time + eval( "1.#{report.unit}" )
      task.total_value( start_time, end_time )
    end
  end

  private
    def set_multiplier
      self.multiplier = 1.0 if multiplier.nil?
    end
end
