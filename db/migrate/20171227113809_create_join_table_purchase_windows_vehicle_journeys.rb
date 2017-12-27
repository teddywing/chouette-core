class CreateJoinTablePurchaseWindowsVehicleJourneys < ActiveRecord::Migration
  def change
    create_join_table :purchase_windows, :vehicle_journeys do |t|
      t.belongs_to :purchase_window
      t.belongs_to :vehicle_journey
      # t.index [:purchase_window_id, :vehicle_journey_id]
      # t.index [:vehicle_journey_id, :purchase_window_id]
    end
  end
end
