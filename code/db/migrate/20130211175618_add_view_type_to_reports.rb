class AddViewTypeToReports < ActiveRecord::Migration
  def change
    add_column :reports, :view_type, :string
  end
end
