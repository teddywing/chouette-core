module Chouette
  class VehicleJourneyAtStop < ActiveRecord
    include ForBoardingEnumerations
    include ForAlightingEnumerations

    DAY_OFFSET_MAX = 1

    # FIXME http://jira.codehaus.org/browse/JRUBY-6358
    self.primary_key = "id"

    belongs_to :stop_point
    belongs_to :vehicle_journey

    attr_accessor :_destroy, :dummy

    validate :arrival_must_be_before_departure
    def arrival_must_be_before_departure
      # security against nil values
      return unless arrival_time && departure_time

      if TimeDuration.exceeds_gap?(4.hours, arrival_time, departure_time)
        errors.add(
          :arrival_time,
          I18n.t("activerecord.errors.models.vehicle_journey_at_stop.arrival_must_be_before_departure")
        )
      end
    end

    validates :arrival_day_offset, numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: DAY_OFFSET_MAX,
      message: ->(object, data) do
        byebug
        I18n.t(
          'vehicle_journey_at_stops.errors.day_offset_must_not_exceed_max',
          local_id: object.vehicle_journey.objectid.local_id,
          max: DAY_OFFSET_MAX + 1
        )
      end
    }
    validates :departure_day_offset, numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: DAY_OFFSET_MAX,
      message: ->(object, data) do
        I18n.t(
          'vehicle_journey_at_stops.errors.day_offset_must_not_exceed_max',
          local_id: object.vehicle_journey.objectid.local_id,
          max: DAY_OFFSET_MAX + 1
        )
      end
    }

    after_initialize :set_virtual_attributes
    def set_virtual_attributes
      @_destroy = false
      @dummy = false
    end

  end
end
