class AddMultiplierToTaskJoiners < ActiveRecord::Migration
  def change
    add_column :task_joiners, :multiplier, :integer
  end
end
