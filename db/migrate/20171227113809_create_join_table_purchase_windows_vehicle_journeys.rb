class CreateJoinTablePurchaseWindowsVehicleJourneys < ActiveRecord::Migration
  def change
    create_join_table :purchase_windows, :vehicle_journeys do |t|
      t.integer :purchase_window_id
      t.integer :vehicle_journey_id
      # t.index [:purchase_window_id, :vehicle_journey_id]
      # t.index [:vehicle_journey_id, :purchase_window_id]
    end
  end
end
