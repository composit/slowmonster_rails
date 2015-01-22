class CreateReportTasks < ActiveRecord::Migration
  def change
    create_table :report_tasks do |t|
      t.references :task
      t.decimal :multiplier, :precision => 10, :scale => 2
      t.references :report

      t.timestamps
    end
    add_index :report_tasks, :task_id
    add_index :report_tasks, :report_id
  end
end
