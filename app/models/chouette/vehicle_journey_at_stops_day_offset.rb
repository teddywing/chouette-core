module Chouette
  class VehicleJourneyAtStopsDayOffset
    def initialize(at_stops)
      @at_stops = at_stops
    end

    # def update

    def calculate!
      @at_stops
    end
  end
end
