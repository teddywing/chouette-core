class WayCost
  attr_reader :departure, :arrival, :id
  attr_accessor :distance, :time

  def initialize(
    departure:,
    arrival:,
    distance: nil,
    time: nil,
    id: nil
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
      @time == other.time &&
      @id == other.id
  end

  def cache_key
    raise NullIDError if !id

    "way_cost/#{id}"
  end

  class NullIDError < RuntimeError; end
end
