class AddKindToStopAreas < ActiveRecord::Migration
  def change
    add_column :stop_areas, :kind, :string
    Chouette::StopArea.where.not(kind: :non_commercial).update_all kind: :commercial
  end
end
