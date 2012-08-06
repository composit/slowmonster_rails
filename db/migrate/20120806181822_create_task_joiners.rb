class CreateTaskJoiners < ActiveRecord::Migration
  def change
    create_table :task_joiners do |t|
      t.references :parent_task
      t.references :child_task

      t.timestamps
    end
    add_index :task_joiners, :parent_task_id
    add_index :task_joiners, :child_task_id
  end
end
