class WayCost
  attr_reader :departure, :arrival
  attr_accessor :distance, :time

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

  def ==(other)
    other.is_a?(self.class) &&
      @departure == other.departure &&
      @arrival == other.arrival &&
      @distance == other.distance &&
      @time == other.time
  end
end
