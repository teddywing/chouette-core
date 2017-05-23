module Chouette
  class VehicleJourneyAtStopsAreInIncreasingTimeOrderValidator <
      ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      increasing_times(record)
    end

    def increasing_times(vehicle_journey)
      # TODO: Rename `previous`
      previous = nil

      vehicle_journey
        .vehicle_journey_at_stops
        .select { |vjas| vjas.departure_time && vjas.arrival_time }
        .each do |vjas|
          unless vjas.increasing_times_validate(previous)
            vehicle_journey.errors.add(
              :vehicle_journey_at_stops,
              'time gap overflow'
            )
          end

          previous = vjas
        end
    end

    def increasing_times_validate( previous)
      result = true
      return result unless previous

      if exceeds_gap?( previous.departure_time, departure_time)
        result = false
        errors.add( :departure_time, 'departure time gap overflow')
      end
      if exceeds_gap?( previous.arrival_time, arrival_time)
        result = false
        errors.add( :arrival_time, 'arrival time gap overflow')
      end
      result
    end

    def exceeds_gap?(earlier, later)
      (4 * 3600) < ((later - earlier) % (3600 * 24))
    end
  end
end
