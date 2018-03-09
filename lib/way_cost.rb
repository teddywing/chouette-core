class WayCost
  attr_reader :departure, :arrival

  def initialize(
    departure:,
    arrival:,
    distance: nil,
    time: nil,
    id: nil  # TODO: calculate ID automatically
  )
    @departure = departure
    @arrival = arrival
    @distance = distance
    @time = time
    @id = id
  end
end
