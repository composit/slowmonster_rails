class AddDaysInWeekToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :days_in_week, :float
  end
end
