module Chouette
  class VehicleJourneyAtStopsAreInIncreasingTimeOrderValidator <
      ActiveModel::EachValidator
    def validate_each(vehicle_journey, attribute, value)
      previous_at_stop = nil

      vehicle_journey
        .vehicle_journey_at_stops
        .select { |vjas| vjas.departure_time && vjas.arrival_time }
        .each do |vjas|
          unless self.class.validate_at_stop_times_must_increase(
            vjas,
            previous_at_stop
          )
            vehicle_journey.errors.add(
              :vehicle_journey_at_stops,
              'time gap overflow'
            )
          end

          previous_at_stop = vjas
        end
    end

    def self.validate_at_stop_times_must_increase(at_stop, previous_at_stop)
      valid = true
      return valid unless previous_at_stop

      if TimeDuration.exceeds_gap?(
        4.hours,
        previous_at_stop.departure_time,
        at_stop.departure_time
      )
        valid = false
        at_stop.errors.add(:departure_time, 'departure time gap overflow')
      end

      if TimeDuration.exceeds_gap?(
        4.hours,
        previous_at_stop.arrival_time,
        at_stop.arrival_time
      )
        valid = false
        at_stop.errors.add(:arrival_time, 'arrival time gap overflow')
      end

      valid
    end
  end
end
