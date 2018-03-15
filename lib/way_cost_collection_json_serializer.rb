class WayCostCollectionJSONSerializer
  def self.dump(way_costs)
    return if way_costs.nil?

    costs_by_id = {}

    way_costs.each do |way_cost|
      costs_by_id[way_cost.id] = {
        distance: way_cost.distance,
        time: way_cost.time
      }
    end

    JSON.dump(costs_by_id)
  end
end
