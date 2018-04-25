class AddIgnoredRoutingContraintZoneIdsToVehicleJourneys < ActiveRecord::Migration
  def change
    add_column :vehicle_journeys, :ignored_routing_contraint_zone_ids, :integer, array: true, default: []
  end
end
