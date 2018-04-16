class WayCostsFromRouteCostsPopulator
  def initialize(way_costs, route_costs)
    @way_costs = way_costs
    @route_costs = route_costs
  end

  def populate!
    @way_costs.map do |way_cost|
      route_cost = @route_costs[way_cost.id]

      if route_cost
        way_cost.distance = route_cost['distance']
        way_cost.time = route_cost['time']
      end

      way_cost
    end
  end
end
