class Report < ActiveRecord::Base
  attr_accessible :duration, :started_at, :unit

  has_many :report_tasks

  validates :unit, presence: true, inclusion: { in: %w(day week month year), allow_blank: true }
  validates :duration, presence: true

  def chart_values
    [headers] + ( [dates] + task_values ).transpose
  end

  def calculated_started_at
    started_at || eval( "#{duration}.#{unit}.ago" )
  end

  def content
    #TODO temporary hardcoding of report content
    content_strings = []

    unless Task.where( content: 'worker dollars' ).empty?
      start_threshold = calculated_started_at
      end_threshold = start_threshold + eval( "#{duration}.#{unit}" )

      worker_dollars = Task.where( content: 'worker dollars' ).first.total_value( start_threshold, end_threshold )
      after_tax_percent = 2.0/3.0
      business_spending = Task.where( content: 'business spending' ).first.total_value( start_threshold, end_threshold )
      worker = Task.where( content: 'worker' ).first.total_value( start_threshold, end_threshold )
      personal_spending = Task.where( content: 'personal spending' ).first.total_value( start_threshold, end_threshold )

      net_income_dollars = ( worker_dollars * after_tax_percent ) - business_spending
      worker_rate = net_income_dollars / worker
      hours_required_per_unit = personal_spending / worker_rate / duration
      personal_spending_per_unit = personal_spending / duration
      content_strings << "You need to work #{hours_required_per_unit} hours per #{unit} to cover your spending of $#{personal_spending} per #{unit}."
    end
    content_strings
  end

  private
    def headers
      ['Date'] + report_tasks.map( &:task_content )
    end

    def task_values
      report_tasks.map { |report_task| report_task.totals_over_time }
    end

    def dates
      1.upto( duration ).map do |offset|
        date = calculated_started_at + eval( "#{offset}.#{unit}" )
        date.strftime( "%B %d, %Y" )
      end
    end
end
