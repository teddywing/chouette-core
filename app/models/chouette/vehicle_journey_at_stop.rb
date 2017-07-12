module Chouette
  class VehicleJourneyAtStop < ActiveRecord
    include ForBoardingEnumerations
    include ForAlightingEnumerations
    include ChecksumSupport

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

    def checksum_attributes
      [].tap do |attrs|
        attrs << self.departure_time.try(:to_s, :time)
        attrs << self.arrival_time.try(:to_s, :time)
        attrs << self.departure_day_offset.to_s
        attrs << self.arrival_day_offset.to_s
      end
    end

    after_initialize :set_virtual_attributes
    def set_virtual_attributes
      @_destroy = false
      @dummy = false
    end

  end
end
