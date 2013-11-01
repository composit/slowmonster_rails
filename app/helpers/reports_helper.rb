module ReportsHelper
  def amount_done_since(task, time)
    task.total_value(time) / (Time.zone.now.to_date - time.to_date + 1)
  end
end
