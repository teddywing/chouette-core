class AddStifTypeToStopArea < ActiveRecord::Migration
  def change
    add_column :stop_areas, :stif_type, :string
  end
end
