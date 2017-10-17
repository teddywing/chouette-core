module VehicleJourneyControl
  class TimeTable < ComplianceControl
    enumerize :criticity, in: %i(error), scope: true

    def self.default_code; "3-VehicleJourney-4" end
  end
end
