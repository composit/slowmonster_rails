class ReportTask < ActiveRecord::Base
  belongs_to :task
  belongs_to :report
  attr_accessible :multiplier

  validates :task, presence: true
  validates :report, presence: true

  def multiplier
    @multiplier ||= 1.0
  end
end
