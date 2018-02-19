class AddLocalizedNamesToStopAreas < ActiveRecord::Migration
  def change
    add_column :stop_areas, :localized_names, :jsonb
  end
end
