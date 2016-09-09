class AddIndexToStopAreas < ActiveRecord::Migration
  def change
    add_index :stop_areas, :name
  end
end
