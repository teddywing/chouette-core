module VehicleJourneyControl
  class Delta < ComplianceControl

    hstore_accessor :control_attributes, delta: :integer

    @@default_code = "3-VehicleJourney-3"
  end
end
