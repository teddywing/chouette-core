class AddStopAreaReferentialToStopAreas < ActiveRecord::Migration
  def change
    add_column :stop_areas, :stop_area_referential_id, :integer
    add_index :stop_areas, :stop_area_referential_id
  end
end
