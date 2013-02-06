class Report < ActiveRecord::Base
  attr_accessible :duration, :started_at, :unit

  has_many :report_tasks

  validates :unit, presence: true, inclusion: { in: %w(day week month year), allow_blank: true }
  validates :duration, presence: true

  def values
    [headers] + ( [dates] + task_values ).transpose
  end

  def calculated_started_at
    started_at || eval( "#{duration + 1}.#{unit}.ago" )
  end

  def dates
    0.upto( duration - 1 ).map do |offset|
      date = calculated_started_at + eval( "#{offset}.#{unit}" )
      date.strftime( "%B %d, %Y" )
    end
  end

  private
    def headers
      ['Date'] + report_tasks.map( &:task_content )
    end

    def task_values
      report_tasks.map { |report_task| report_task.totals_over_time }
    end
end
