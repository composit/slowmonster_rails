class ReportTask < ActiveRecord::Base
  belongs_to :task
  belongs_to :report
  attr_accessible :multiplier

  validates :task, presence: true
  validates :report, presence: true
  
  after_initialize :set_multiplier

  private
    def set_multiplier
      self.multiplier = 1.0 if multiplier.nil?
    end
end
