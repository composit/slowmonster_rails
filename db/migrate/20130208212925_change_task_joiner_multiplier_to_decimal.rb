class ChangeTaskJoinerMultiplierToDecimal < ActiveRecord::Migration
  def up
    change_column :task_joiners, :multiplier, :decimal, precision: 10, scale: 9
  end

  def down
    change_column :task_joiners, :multiplier, :integer
  end
end
