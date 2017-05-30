module Chouette
  class VehicleJourneyAtStopsDayOffset
    def initialize(at_stops)
      @at_stops = at_stops
    end

    def calculate!
      start_date = @at_stops.first.arrival_time.to_date
      offset = 0

      arrival_offset = 0
      departure_offset = 0

      # @at_stops.each do |at_stop|
      #   if at_stop.arrival_time.to_date != start_date
      #     offset = at_stop.arrival_time.to_date - start_date
      #   end
      #
      #   if at_stop.departure_time.to_date != start_date
      #     offset = at_stop.departure_time.to_date - start_date
      #   end
      #
      #   at_stop.arrival_day_offset = offset
      #   at_stop.departure_day_offset = offset
      # end

      # Check that the current time is later than the previous time.
      # If earlier, it's a new day offset
      # Otherwise, we keep the current day offset

      # TODO: Don't like this
      previous_at_stop = @at_stops.first

      @at_stops.each_with_index do |at_stop, index|
        next if index == 0

        if previous_at_stop.departure_time > at_stop.arrival_time ||
            at_stop.arrival_time < previous_at_stop.arrival_time
          arrival_offset += 1
        end

        # Departure time is earlier than arrival time
        # or
        # Departure time is earlier than previous departure time
        if at_stop.departure_time < at_stop.arrival_time ||
            at_stop.departure_time < previous_at_stop.departure_time
          departure_offset += 1
        end

        at_stop.arrival_day_offset = arrival_offset
        at_stop.departure_day_offset = departure_offset

        previous_at_stop = at_stop
      end
    end

    def save
      @at_stops.each do |at_stop|
        at_stop.save
      end
    end

    def update
      calculate!
      save
    end
  end
end
