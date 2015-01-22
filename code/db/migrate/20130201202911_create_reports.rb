class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.datetime :started_at
      t.string :unit
      t.integer :duration

      t.timestamps
    end
  end
end
