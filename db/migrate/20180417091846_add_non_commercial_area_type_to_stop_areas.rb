class AddNonCommercialAreaTypeToStopAreas < ActiveRecord::Migration
  def change
    add_column :stop_areas, :non_commercial_area_type, :string
    Chouette::StopArea.where(area_type: Chouette::AreaType.non_commercial).update_all "non_commercial_area_type = area_type, area_type = NULL"
  end
end
