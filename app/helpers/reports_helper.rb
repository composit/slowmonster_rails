module ReportsHelper
  def report_color(task, low_amount_expected, high_amount_expected)
    since_time = 1.week.ago
    color = 'green'
    color = 'yellow' if amount_done_since(task, since_time) > low_amount_expected
    color = 'red' if amount_done_since(task, since_time) > high_amount_expected
    color
  end
end
