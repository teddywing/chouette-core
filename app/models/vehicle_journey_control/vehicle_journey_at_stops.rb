module VehicleJourneyControl
  class VehicleJourneyAtStops < ComplianceControl
    enumerize :criticity, in: %i(error), scope: true

    def self.default_code; "3-VehicleJourney-5" end
  end
end
