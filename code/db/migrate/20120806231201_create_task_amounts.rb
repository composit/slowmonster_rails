class CreateTaskAmounts < ActiveRecord::Migration
  def change
    create_table :task_amounts do |t|
      t.decimal :amount
      t.datetime :incurred_at
      t.references :task

      t.timestamps
    end
    add_index :task_amounts, :task_id
  end
end
