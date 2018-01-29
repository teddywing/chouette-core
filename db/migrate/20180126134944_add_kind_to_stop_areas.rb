class AddKindToStopAreas < ActiveRecord::Migration
  def change
    add_column :stop_areas, :kind, :string
    Chouette::StopArea.update_all kind: :commmercial
  end
end
