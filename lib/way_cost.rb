class WayCost
  def initialize(
    departure:,
    arrival:,
    distance: nil,
    time: nil,
    id:,  # TODO: calculate ID automatically
  )
    @departure = departure
    @arrival = arrival
    @distance = distance
    @time = time
    @id = id
  end
end
