class AddKindToStopAreas < ActiveRecord::Migration
  def change
    add_column :stop_areas, :kind, :string
  end
end
