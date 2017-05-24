module Chouette
  class VehicleJourneyAtStopsAreInIncreasingTimeOrderValidator <
      ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      increasing_times(record)
    end

    def increasing_times(vehicle_journey)
      previous_at_stop = nil

      vehicle_journey
        .vehicle_journey_at_stops
        .select { |vjas| vjas.departure_time && vjas.arrival_time }
        .each do |vjas|
          unless vjas.increasing_times_validate(previous_at_stop)
            vehicle_journey.errors.add(
              :vehicle_journey_at_stops,
              'time gap overflow'
            )
          end

          previous_at_stop = vjas
        end
    end

    def increasing_times_validate(previous_at_stop)
      result = true
      return result unless previous_at_stop

      if exceeds_gap?(previous_at_stop.departure_time, departure_time)
        result = false
        errors.add( :departure_time, 'departure time gap overflow')
      end
      if exceeds_gap?(previous_at_stop.arrival_time, arrival_time)
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
