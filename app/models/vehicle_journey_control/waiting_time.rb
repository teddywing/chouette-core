module VehicleJourneyControl
  class WaitingTime < ComplianceControl
    hstore_accessor :control_attributes, maximum: :integer

    def self.default_code; "3-VehicleJourney-1" end
  end
end
