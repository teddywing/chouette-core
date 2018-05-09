require 'rgeo_ext'

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

  def calculate_distance
    departure = RGeoExt.geographic_factory.point(@departure.lng, @departure.lat)
    arrival = RGeoExt.geographic_factory.point(@arrival.lng, @arrival.lat)

    departure.distance(arrival)
  end
end
