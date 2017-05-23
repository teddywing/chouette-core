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
  end
end
