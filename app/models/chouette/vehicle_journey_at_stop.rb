module Chouette
  class VehicleJourneyAtStop < ActiveRecord
    include ForBoardingEnumerations
    include ForAlightingEnumerations

    # FIXME http://jira.codehaus.org/browse/JRUBY-6358
    self.primary_key = "id"

    belongs_to :stop_point
    belongs_to :vehicle_journey

    attr_accessor :_destroy

    validate :arrival_must_be_before_departure
    def arrival_must_be_before_departure
      # security against nil values
      return unless arrival_time && departure_time

      if TimeDuration.exceeds_gap?(4.hours, arrival_time, departure_time)
        errors.add(:arrival_time,I18n.t("activerecord.errors.models.vehicle_journey_at_stop.arrival_must_be_before_departure"))
      end
    end

    after_initialize :set_virtual_attributes
    def set_virtual_attributes
      @_destroy = false
    end

  end
end
