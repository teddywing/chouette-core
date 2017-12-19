module VehicleJourneyControl
  class Delta < ComplianceControl

    store_accessor :control_attributes, :maximum

    validates :maximum, numericality: true, allow_nil: true

    def self.default_code; "3-VehicleJourney-3" end
  end
end
