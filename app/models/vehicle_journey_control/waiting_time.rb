module VehicleJourneyControl
  class WaitingTime < ComplianceControl
    hstore_accessor :control_attributes, maximum: :integer

    validates :maximum, numericality: true, allow_nil: true

    def self.default_code; "3-VehicleJourney-1" end
  end
end
