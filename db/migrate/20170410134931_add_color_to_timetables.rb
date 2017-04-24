class AddColorToTimetables < ActiveRecord::Migration
  def change
    add_column :time_tables, :color, :string
  end
end
