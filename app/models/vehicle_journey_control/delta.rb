module VehicleJourneyControl
  class Delta < ComplianceControl

    hstore_accessor :control_attributes, maximum: :integer

    def self.default_code; "3-VehicleJourney-3" end
  end
end
