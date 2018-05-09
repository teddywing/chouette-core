class WayCostMinimumDistance
  MINIMUM_DISTANCE_METERS = 500
  SNAP_TO_METERS = 1000

  def initialize(way_costs)
    @way_costs = way_costs
  end

  def snap_short_costs_to_1
    @way_costs.map do |way_cost|
      distance = way_cost.calculate_distance

      if distance < MINIMUM_DISTANCE_METERS
        way_cost.distance = SNAP_TO_METERS
      end

      way_cost
    end
  end
end
